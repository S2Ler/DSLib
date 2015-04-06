
#pragma mark - include
#import "DSQueueBasedRequestSender.h"
#import "DSWebServiceQueue.h"
#import "DSWebServiceParams.h"
#import "DSWebServiceRequestsFactory.h"
#import "DSMessage.h"
#import "DSQueueRecurrentRequestPolicy.h"
#import "DSQueueBasedRequestSender+Private.h"
#import "NSError+DSWebService.h"
#import "NSString+Extras.h"
#import "DSMessageInterceptor.h"
#import "DSTimeFunctions.h"
#import "NSDate+OAddittions.h"
#import "NSTimer+DSAdditions.h"
#import "NSDate+DateTools.h"
#import "DSWeakTimerTarget.h"
#import "DSInterceptorsMap.h"
#import "DSInterceptedMessageMetadata.h"

#define COMPLETION_USER_INFO_KEY @"Completion"
#define REQUEST_SUCCESSFUL_HANDLER_USER_INFO_KEY @"Request Successful"
#define REQUEST_FAILED_HANDLER_USER_INFO_KEY @"Request Failed"

static DSInterceptorsMap *interceptorsMap = nil;

@interface DSQueueRecurrentRequestData : NSObject
@property (nonatomic, strong) DSWebServiceParams *params;
@property (nonatomic, copy) ds_results_completion completion;
@property (nonatomic, copy) request_successful_block_t requestSuccessfulHandler;
@property (nonatomic, copy) request_failed_block_t requestFailedHandler;
@property (nonatomic, copy) NSDictionary *userInfo;
@property (nonatomic, strong) dispatch_queue_t callbackQueue;
@property (nonatomic, strong) DSQueueRecurrentRequestPolicy *policy;

@property (nonatomic, strong) NSDate *nextFireDate;

- (void)updateNextFireDate;
@end

#pragma mark - private
@interface DSQueueBasedRequestSender () {
  dispatch_queue_t _workingQueue;
}
@property (strong) DSWebServiceQueue *queue;
@property (nonatomic, strong) NSOperationQueue *waitCompletionQueue;
@property (nonatomic, strong) NSMutableDictionary *recurrentRequestsData;
@property (nonatomic, strong) NSTimer *recurrentRequestsTimer;
@end

@implementation DSQueueBasedRequestSender

- (void)dealloc
{
  [[self queue] removeObserver:self forKeyPath:@"operationCount"];
  [self.recurrentRequestsTimer invalidate];
}

#pragma mark - Props
- (void)setWorkingQueue:(dispatch_queue_t)workingQueue
{
  _workingQueue = workingQueue;
}

- (dispatch_queue_t)workingQueue
{
  if (!_workingQueue) {
    _workingQueue = dispatch_queue_create([NSStringFromClass([self class]) UTF8String], DISPATCH_QUEUE_SERIAL);
  }
  
  return _workingQueue;
}

#pragma mark - init
- (id)init
{
  self = [super init];
  if (self) {
    _queue = [[DSWebServiceQueue alloc] initWithTarget:self];
    [_queue setName:NSStringFromClass([self class])];
    [_queue setSuspended:NO];
    [_queue addObserver:self
             forKeyPath:@"operationCount"
                options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld
                context:(__bridge void *)self];
    _recurrentRequestsData = [NSMutableDictionary dictionary];

    dispatch_sync([self workingQueue], ^{
      DSWeakTimerTarget *weakTarget = [[DSWeakTimerTarget alloc] initWithTarget:self
                                                                       selector:@selector(processRecurrentRequests)];
      _recurrentRequestsTimer = [NSTimer scheduledTimerWithTimeInterval:NSTimeIntervalWithMinutes(1)
                                                                 target:weakTarget
                                                               selector:@selector(timerDidFire:)
                                                               userInfo:nil
                                                                repeats:YES];
    });
    
    ASSERT_MAIN_THREAD;//BUG: should be inited on main thread otherwise requests isn't deallocated. Can't find why
  }

  return self;
}

- (BOOL)isSuspended
{
  return [[self queue] isSuspended];
}

- (void)setSuspended:(BOOL)suspended
{
  [[self queue] setSuspended:suspended];
}

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context
{
  if (context == (__bridge void *)self) {
    if ([keyPath isEqualToString:@"operationCount"]) {
      [self requestCountChanged];
    }
  }
  else {
    [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
  }
}

#pragma mark - DSWebServiceQueue action
- (void)requestFinished:(id<DSWebServiceRequest>)request
{
  //
}

#pragma mark - finishin
- (NSArray *)activeRequests
{
  return [[self queue] operations];
}

- (id<DSWebServiceRequest>)activeRequestForParamsClass:(Class)paramsClass
{
  for (id<DSWebServiceRequest> activeRequest in [self activeRequests]) {
    if ([paramsClass isCorrespondsToRequest:activeRequest]) {
      return activeRequest;
    }
  }
  
  return nil;
}

- (NSInteger)requestCount
{
  return [[self queue] operationCount];
}

- (void)requestCountChanged
{
  //
}

- (NSOperationQueue *)waitCompletionQueue
{
  if (!_waitCompletionQueue) {
    _waitCompletionQueue = [[NSOperationQueue alloc] init];
    [_waitCompletionQueue setSuspended:NO];
    [_waitCompletionQueue setName:@"DSQueueBasedRequestSender cancel wait queue"];
  }
  
  return _waitCompletionQueue;
}

#pragma mark - Message Interception
+ (DSInterceptorsMap *)interceptorsMap
{
  static dispatch_once_t pred = 0;
  dispatch_once(&pred, ^{
    interceptorsMap = [[DSInterceptorsMap alloc] init];
  });
  
  return interceptorsMap;
}

+ (void)addMessageInterceptor:(DSMessageInterceptor *)interceptor;
{
  [[self interceptorsMap] addInterceptor:interceptor];
}

+ (void)removeMessageInterceptor:(DSMessageInterceptor *)interceptor
{
  [[self interceptorsMap] removeInterceptor:interceptor];
}

+ (NSArray *)interceptorsForMessage:(DSMessage *)message
{
  return [[self interceptorsMap] interceptorsForMessage:message];
}

#pragma mark - Recurrent Requests
- (void)processRecurrentRequests
{
  NSDate *now = [NSDate now];
  for (DSQueueRecurrentRequestData *requestData in [[self recurrentRequestsData] allValues]) {
    [self processRecurrentRequestData:requestData withNow:now];
  }
}

- (void)processRecurrentRequestData:(DSQueueRecurrentRequestData *)data withNow:(NSDate *)now
{
  if ([[data nextFireDate] isLaterThan:now]) {
    return;
  }
  
  [self sendRequestFromData:data];
  [data updateNextFireDate];
}

- (void)sendRequestFromData:(DSQueueRecurrentRequestData *)data
{
  [self sendRequestWithParams:data.params
                   completion:data.completion
     requestSuccessfulHandler:data.requestSuccessfulHandler
         requestFailedHandler:data.requestFailedHandler
                     userInfo:data.userInfo
                callbackQueue:data.callbackQueue];
}


@end


@implementation DSQueueBasedRequestSender (Private)
- (id<DSWebServiceRequest>)sendRequestWithParams:(DSWebServiceParams *)params
                                      completion:(ds_results_completion)completion
{
  return [self sendRequestWithParams:params completion:completion requestSuccessfulHandler:nil];
}

- (id<DSWebServiceRequest>)sendRequestWithParams:(DSWebServiceParams *)params
                                      completion:(ds_results_completion)completion
                        requestSuccessfulHandler:(request_successful_block_t)requestSuccessfulHandler
{
  return [self sendRequestWithParams:params
                          completion:completion
            requestSuccessfulHandler:requestSuccessfulHandler
                            userInfo:nil];
}

- (id<DSWebServiceRequest>)sendRequestWithParams:(DSWebServiceParams *)params
                                      completion:(ds_results_completion)completion
                        requestSuccessfulHandler:(request_successful_block_t)requestSuccessfulHandler
                                   callbackQueue:(dispatch_queue_t)callbackQueue;
{
  return [self sendRequestWithParams:params
                          completion:completion
            requestSuccessfulHandler:requestSuccessfulHandler
                requestFailedHandler:nil
                            userInfo:nil
                       callbackQueue:callbackQueue];
}

- (id<DSWebServiceRequest>)sendRequestWithParams:(DSWebServiceParams *)params
                                      completion:(ds_results_completion)completion
                        requestSuccessfulHandler:(request_successful_block_t)requestSuccessfulHandler
                                        userInfo:(NSDictionary *)userInfo
{
  return [self sendRequestWithParams:params
                          completion:completion
            requestSuccessfulHandler:requestSuccessfulHandler
                requestFailedHandler:nil
                            userInfo:userInfo];
}

- (id<DSWebServiceRequest>)sendRequestWithParams:(DSWebServiceParams *)params
                                      completion:(ds_results_completion)completion
                        requestSuccessfulHandler:(request_successful_block_t)requestSuccessfulHandler
                            requestFailedHandler:(request_failed_block_t)requestFailedHandler
                                        userInfo:(NSDictionary *)userInfo
{
  return [self sendRequestWithParams:params
                          completion:completion
            requestSuccessfulHandler:requestSuccessfulHandler
                requestFailedHandler:requestFailedHandler
                            userInfo:userInfo
                       callbackQueue:dispatch_get_main_queue()];
}

- (id<DSWebServiceRequest>)sendRequestWithParams:(DSWebServiceParams *)params
                                      completion:(ds_results_completion)completion
                        requestSuccessfulHandler:(request_successful_block_t)requestSuccessfulHandler
                            requestFailedHandler:(request_failed_block_t)requestFailedHandler
                                        userInfo:(NSDictionary *)userInfo
                                   callbackQueue:(dispatch_queue_t)callbackQueue
{
//  UIBackgroundTaskIdentifier taskID = [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:^{
//    //
//  }];
  
  id<DSWebServiceRequest> request = [DSWebServiceRequestsFactory requestWithParams:params];
  [request setDelegate:self];
  
  __weak id<DSWebServiceRequest> weakRequest = request;
  if (userInfo) {
    [request setUserInfo:[userInfo mutableCopy]];
  }
  
  void (^finishWithErrorBlock)(DSMessage *errorMessage) = ^(DSMessage *errorMessage) {
    NSArray *globalInterceptors = [DSQueueBasedRequestSender interceptorsForMessage:errorMessage];
    if ([globalInterceptors count] > 0) {
      NSLog(@"%@", params);
      for (DSMessageInterceptor *interceptor in globalInterceptors) {
        if (interceptor.isActive && [interceptor shouldInterceptParams:params]) {
          DSInterceptedMessageMetadata *interceptedMetadata = [DSInterceptedMessageMetadata new];
          interceptedMetadata.message = errorMessage;
          interceptedMetadata.params = params;
          interceptor.handler(interceptedMetadata);
          
          if (!interceptor.shouldAllowOthersToProceed) {
            errorMessage = nil;
          }
        }
      }
    }
    
    if (requestFailedHandler) {
      requestFailedHandler(weakRequest, errorMessage, completion);
    }
    else if (completion) {
      completion(FAILED_WITH_MESSAGE, errorMessage, NO_RESULTS);
    }
  };

  [request setCompletionBlock:^{
    void (^finish)() = ^{
//      [[UIApplication sharedApplication] endBackgroundTask:taskID];
      
      if ([weakRequest error]) {
        finishWithErrorBlock([DSMessage messageWithError:[weakRequest error]]);
        return;
      }
      
      DSWebServiceResponse *response = [weakRequest response];
      BOOL isRequestWithOutputPath = [params outputPath] != nil;
      
      if (isRequestWithOutputPath || [response isServerResponse]) {
        if (isRequestWithOutputPath || [response isSuccessfulResponse]) {
          if (requestSuccessfulHandler) {
            requestSuccessfulHandler(weakRequest, response, completion);
          }
          else if (completion) {
            completion(YES, nil, nil);
          }
        }
        else {
          finishWithErrorBlock([response APIErrorMessage]);
        }
      }
      else {
        DSMessage *unknownErrorMessage = [DSMessage messageWithDomain:kDSMessageDomainWebService
                                                                 code:kDSMessageDomainWebServiceErrorUnknown];
        
        finishWithErrorBlock(unknownErrorMessage);
      }
    };
    
    dispatch_sync(callbackQueue, finish);
  }];
  
  
  [[self queue] addRequest:request finishedAction:@selector(requestFinished:)];
  
  return request;
}

- (void)cancelAllRequestsWithCompletion:(ds_completion_handler)completion
{
  if (completion) {
    __weak NSOperationQueue *weakQueue = [self queue];
    [[self waitCompletionQueue] addOperationWithBlock:^{
      [[self queue] cancelAllOperations];
      [weakQueue waitUntilAllOperationsAreFinished];
      [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        completion(YES, nil);
      }];
    }];
  }
}

- (void)cancelAllRequestsWithCompletion:(ds_completion_handler)completion queue:(dispatch_queue_t)queue
{
  if (completion) {
    __weak NSOperationQueue *weakQueue = [self queue];
    [[self waitCompletionQueue] addOperationWithBlock:^{
      [[self queue] cancelAllOperations];
      [weakQueue waitUntilAllOperationsAreFinished];
      dispatch_async(queue, ^{completion(YES, nil);});
    }];
  }
}

- (void)removeAllRecurrentRequests
{
  [[self recurrentRequestsData] removeAllObjects];
}

- (void)addRecurrentRequestWithParams:(DSWebServiceParams *)params
                           completion:(ds_results_completion)completion
             requestSuccessfulHandler:(request_successful_block_t)requestSuccessfulHandler
                 requestFailedHandler:(request_failed_block_t)requestFailedHandler
                             userInfo:(NSDictionary *)userInfo
                        callbackQueue:(dispatch_queue_t)callbackQueue
                      recurrentPolicy:(DSQueueRecurrentRequestPolicy *)policy
                           requestKey:(NSString *)requestKey
{
  DSQueueRecurrentRequestData *requestData = [[DSQueueRecurrentRequestData alloc] init];
  requestData.params = params;
  requestData.completion = completion;
  requestData.requestSuccessfulHandler = requestSuccessfulHandler;
  requestData.requestFailedHandler = requestFailedHandler;
  requestData.userInfo = userInfo;
  requestData.callbackQueue = callbackQueue;
  requestData.policy = policy;
  
  if (policy.runOnAdd) {
    requestData.nextFireDate = [NSDate now];
  }
  else {
    [requestData updateNextFireDate];
  }
  
  [self recurrentRequestsData][requestKey] = requestData;
  
  dispatch_async(self.workingQueue, ^{
    [[self recurrentRequestsTimer] fireAndReschedule];
  });
}


@end

@implementation DSQueueRecurrentRequestData
- (void)updateNextFireDate
{
  [self setNextFireDate:[[NSDate now] dateByAddingTimeInterval:self.policy.repeatTimeInterval]];
}
@end
