
#pragma mark - include
#import "DSQueueBasedRequestSender.h"
#import "DSWebServiceQueue.h"
#import "DSWebServiceParams.h"
#import "DSWebServiceRequestsFactory.h"
#import "DSMessage.h"
#import "DSQueueBasedRequestSender+Private.h"
#import "NSError+DSWebService.h"

#define COMPLETION_USER_INFO_KEY @"Completion"
#define REQUEST_SUCCESSFUL_HANDLER_USER_INFO_KEY @"Request Successful"
#define REQUEST_FAILED_HANDLER_USER_INFO_KEY @"Request Failed"

#pragma mark - private
@interface DSQueueBasedRequestSender ()
@property (nonatomic, strong) DSWebServiceQueue *queue;
@property (nonatomic, strong) NSOperationQueue *waitCompletionQueue;
@end

@implementation DSQueueBasedRequestSender

- (void)dealloc
{
  [[self queue] removeObserver:self forKeyPath:@"operationCount"];
}

- (id)init
{
  self = [super init];
  if (self) {
    _queue = [[DSWebServiceQueue alloc] initWithTarget:self];
    [_queue setName:@"DSQueueBasedRequestSender requests queue"];
    [_queue setSuspended:NO];
    [_queue addObserver:self
             forKeyPath:@"operationCount"
                options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld
                context:(__bridge void *)self];
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

- (void)storeCompletion:(ds_results_completion)completion forRequest:(id<DSWebServiceRequest>)request
{
  if (!completion) {
    return;
  }

  NSMutableDictionary *userInfo = [request userInfo];
  if (![userInfo isKindOfClass:[NSMutableDictionary class]]) {
    userInfo = [userInfo mutableCopy];
  }

  if (!userInfo) {
    userInfo = [NSMutableDictionary dictionary];
  }

  [userInfo setValue:[completion copy] forKey:COMPLETION_USER_INFO_KEY];
  [request setUserInfo:userInfo];
}

- (ds_results_completion)completionForRequest:(id<DSWebServiceRequest>)request
{
  return [[request userInfo] valueForKey:COMPLETION_USER_INFO_KEY];
}

#pragma mark - DSWebServiceQueue action
- (void)requestFinished:(id<DSWebServiceRequest>)request
{
  //
}

#pragma mark - DSWebServiceRequestDelegate
- (void)webServiceRequest:(id<DSWebServiceRequest>)theRequest didFailWithError:(NSError *)theError
{
  [self finishWithErrorMessage:[DSMessage messageWithError:theError] request:theRequest];
}

- (void)webServiceRequest:(id<DSWebServiceRequest>)theRequest didEndLoadWithResponse:(DSWebServiceResponse *)theResponse
{
  if ([theResponse isServerResponse]) {
    if ([theResponse isSuccessfulResponse]) {
      request_successful_block_t finishing = [self requestSuccessfulCompletionForRequest:theRequest];
      ds_results_completion completion = [self completionForRequest:theRequest];
      if (finishing) {
        finishing(theRequest, theResponse, completion);
      }
      else if (completion) {
        completion(YES, nil, nil);
      }
    }
    else {
      [self finishWithErrorMessage:[theResponse APIErrorMessage] request:theRequest];
    }
  }
  else {
    DSMessage *unknownErrorMessage = [DSMessage messageWithDomain:kDSMessageDomainWebService
                                                             code:kDSMessageDomainWebServiceErrorUnknown];

    [self finishWithErrorMessage:unknownErrorMessage request:theRequest];
  }
}

#pragma mark - finishing
- (void)finishWithErrorMessage:(DSMessage *)theMessage request:(id<DSWebServiceRequest>)request
{
  request_failed_block_t requestFailedHandler = [self requestFailedCompletionForRequest:request];
  ds_results_completion completionForRequest = [self completionForRequest:request];

  if (requestFailedHandler) {
    requestFailedHandler(request, theMessage, completionForRequest);
  }
  else if (completionForRequest) {
    completionForRequest(FAILED_WITH_MESSAGE, theMessage, NO_RESULTS);
  }
}

- (NSArray *)activeRequests
{
  return [[self queue] operations];
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
  id<DSWebServiceRequest> request = [DSWebServiceRequestsFactory requestWithParams:params];
  [request setDelegate:self];
  if (userInfo) {
    [request setUserInfo:[userInfo mutableCopy]];
  }

  [self storeCompletion:completion forRequest:request];
  [self storeRequestSuccessfulCompletion:requestSuccessfulHandler forRequest:request];
  [self storeRequestFailedCompletion:requestFailedHandler forRequest:request];

  [[self queue] addRequest:request finishedAction:@selector(requestFinished:)];

  return request;
}

- (void)storeRequestSuccessfulCompletion:(request_successful_block_t)completion
                              forRequest:(id<DSWebServiceRequest>)request
{
  if (!completion) {
    return;
  }

  NSMutableDictionary *userInfo = [request userInfo];
  if (![userInfo isKindOfClass:[NSMutableDictionary class]]) {
    userInfo = [userInfo mutableCopy];
  }

  if (!userInfo) {
    userInfo = [NSMutableDictionary dictionary];
  }

  [userInfo setValue:[completion copy] forKey:REQUEST_SUCCESSFUL_HANDLER_USER_INFO_KEY];

  [request setUserInfo:userInfo];
}

- (request_successful_block_t)requestSuccessfulCompletionForRequest:(id<DSWebServiceRequest>)request
{
  return [[request userInfo] valueForKey:REQUEST_SUCCESSFUL_HANDLER_USER_INFO_KEY];
}

- (void)storeRequestFailedCompletion:(request_failed_block_t)completion
                          forRequest:(id<DSWebServiceRequest>)request
{
  if (!completion) {
    return;
  }

  NSMutableDictionary *userInfo = [request userInfo];
  if (![userInfo isKindOfClass:[NSMutableDictionary class]]) {
    userInfo = [userInfo mutableCopy];
  }

  if (!userInfo) {
    userInfo = [NSMutableDictionary dictionary];
  }

  [userInfo setValue:[completion copy] forKey:REQUEST_FAILED_HANDLER_USER_INFO_KEY];

  [request setUserInfo:userInfo];
}

- (request_failed_block_t)requestFailedCompletionForRequest:(id<DSWebServiceRequest>)request
{
  return [[request userInfo] valueForKey:REQUEST_FAILED_HANDLER_USER_INFO_KEY];
}

- (void)cancelAllRequestsWithCompletion:(ds_completion_handler)completion
{
  [[self queue] cancelAllOperations];
  if (completion) {
    __weak NSOperationQueue *weakQueue = [self queue];
    [[self waitCompletionQueue] addOperationWithBlock:^{
      [weakQueue waitUntilAllOperationsAreFinished];
      [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        completion(YES, nil);
      }];
    }];
  }
}

- (void)cancelAllRequestsWithCompletion:(ds_completion_handler)completion queue:(dispatch_queue_t)queue
{
  [[self queue] cancelAllOperations];
  if (completion) {
    __weak NSOperationQueue *weakQueue = [self queue];
    [[self waitCompletionQueue] addOperationWithBlock:^{
      [weakQueue waitUntilAllOperationsAreFinished];
      dispatch_async(queue, ^{
        completion(YES, nil);
      });
    }];
  }
}

@end
