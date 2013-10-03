
#pragma mark - include
#import "DSWebServiceSerialQueue.h"
#import "DSQueue.h"
#import "DSWebServiceNetRequest.h"
#import "DSWebServiceResponse.h"

#define RETRY_KEY @"retryCountKey"

#pragma mark - private
@interface DSWebServiceSerialQueue ()
{
  BOOL _isSuspended;
}

/** Contains all request which haven't been finished yet.
 Running requests also here. */
@property (nonatomic, retain) DSQueue *queue;

/** request from queue which is being proceed at that moment */
@property (nonatomic, retain) id<DSWebServiceRequest> currentRequest;

@property (nonatomic, assign) UIBackgroundTaskIdentifier backgroundTaskID;

- (void)processQueue;
- (void)stopCurrentRequest;

- (void)startBackgroundTask;
- (void)endBackgroundTask;

//retry count
- (NSUInteger)retryCountFromUserInfo:(NSDictionary *)theUserInfo;
- (NSMutableDictionary *)userInfoWithRetryCount:(NSUInteger)theCount
                                   fromUserInfo:(NSDictionary *)theUserInfo;
- (NSMutableDictionary *)userInfoWithIncreasedRetryCountBy:(NSInteger)theIncreaseValue
                                              fromUserInfo:(NSDictionary *)theUserInfo;
@end


@implementation DSWebServiceSerialQueue
#pragma mark - synth
@synthesize queue = _queue;
@synthesize currentRequest = _currentRequest;
@synthesize repeatCount = _repeatCount;
@synthesize timeout = _timeout;
@synthesize didFinishHandler = _didFinishHandler;
@synthesize didFailHandler = _didFailHandler;
@synthesize didEmptyQueueHandler = _didEmptyQueueHandler;
@synthesize backgroundTaskID = _backgroundTaskID;

#pragma mark - memory
- (void)dealloc {  
  [[self class] cancelPreviousPerformRequestsWithTarget:self];
  [self reset]; 
}

#pragma mark - init
- (id)initWithRepeatCount:(NSUInteger)theRepeatCount
             retryTimeout:(NSTimeInterval)theTimeout {
  self = [super init];
  
  if (self) {
    _repeatCount = theRepeatCount;
    _timeout = theTimeout;
    _queue = [[DSQueue alloc] init];
    _isSuspended = YES;
  }
  
  return self;
}

#pragma mark - public
- (void)addRequest:(id<DSWebServiceRequest>)theRequest
{
  if ([self backgroundTaskID] != UIBackgroundTaskInvalid) {
    [self startBackgroundTask];
  }
  if ([theRequest userInfo] == nil) {
    [theRequest setUserInfo:[NSMutableDictionary dictionaryWithObject:[NSNumber numberWithInt:0]
                                                               forKey:RETRY_KEY]];    
  } else {
    NSMutableDictionary *userInfo = [[theRequest userInfo] mutableCopy];
    [userInfo setObject:[NSNumber numberWithInt:0] forKey:RETRY_KEY];
    [theRequest setUserInfo:userInfo];
  }
      
  [_queue pushBack:theRequest];
  [self processQueue];
}

- (void)setSuspended:(BOOL)theSuspendedFlag
{
  [self willChangeValueForKey:@"isSuspended"];
  BOOL suspendingChanged = theSuspendedFlag != _isSuspended;
  
  _isSuspended = theSuspendedFlag;  
  
  if (suspendingChanged) {
    if (_isSuspended == NO) {
      [self processQueue];
    } else {
      [self stopCurrentRequest];
    }
  } 
  
  [self didChangeValueForKey:@"isSuspended"];
}

- (BOOL)isSuspended
{
  return _isSuspended;
}

- (void)reset
{
  [self setSuspended:YES];
  [[self queue] removeAll];
}

#pragma mark - Queue
- (void)processQueue
{
  if ([self currentRequest] || _isSuspended) {
    return;
  }
  
  NSMutableArray *requestToDrop = [NSMutableArray array];
  
  for (id<DSWebServiceRequest> request in [[self queue] reverseObjectEnumerator]) {
    NSUInteger requestRetryCount 
    = [self retryCountFromUserInfo:[request userInfo]];
    
    if (requestRetryCount >= _repeatCount) {//we should drop it then
      [requestToDrop addObject:request];
    } else {
      [self setCurrentRequest:request];
      break;
    }        
  }
  
  [[self queue] removeObjectsInArray:requestToDrop];
  
  if ([[self queue] count] <= 0 && [self didEmptyQueueHandler]) {
    [self endBackgroundTask];
    [self didEmptyQueueHandler]();
  }
  
  [[self currentRequest] setDelegate:self];
  [[self currentRequest] send];
}

- (void)stopCurrentRequest
{
  [[self currentRequest] cancel];
  [self setCurrentRequest:nil];
}

- (NSInteger)countActiveRequests
{  
  return [[self queue] count];
}

#pragma mark - PGWebServiceRequestDelegate
- (void)webServiceRequest:(id<DSWebServiceRequest>)theRequest
       didFailWithError:(NSError *)theError
{    
  NSMutableDictionary *updatedUserInfo 
  = [self userInfoWithIncreasedRetryCountBy:1
                               fromUserInfo:[theRequest userInfo]];
  [theRequest setUserInfo:updatedUserInfo];
  [self setCurrentRequest:nil];
  
  if (_didFailHandler) {
    _didFailHandler(self, theRequest, nil, theError);
  }

  if ([[self queue] count] <= 0 && [self didEmptyQueueHandler]) {
    [self didEmptyQueueHandler]();
  }  

  [self performSelector:@selector(processQueue)
             withObject:nil 
             afterDelay:_timeout];
}

- (void)webServiceRequest:(id<DSWebServiceRequest>)theRequest
   didEndLoadWithResponse:(DSWebServiceResponse *)theResponse
{
  //remove successful request from queue
  [[self queue] pop];    
      
  [self setCurrentRequest:nil];
  
  if (_didFinishHandler) {
    [theResponse parse];     
    _didFinishHandler(self, theRequest, theResponse, nil);
  }
  
  if ([[self queue] count] <= 0 && [self didEmptyQueueHandler]) {
    [self didEmptyQueueHandler]();
  }
  
  [self processQueue];
}

- (NSString *)description
{
  NSMutableString *result = [NSMutableString string];
  
  for (id<DSWebServiceRequest>request in [_queue objectEnumerator]) {
    [result appendFormat:@"%@\n", request];
  }
  
  return result;
}

- (void)startBackgroundTask
{
  __block id weakSelf = self;
  UIBackgroundTaskIdentifier taskID =
  [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:^{
    [weakSelf endBackgroundTask];
  }];
  [self setBackgroundTaskID:taskID];
}

- (void)endBackgroundTask
{
  [[UIApplication sharedApplication] endBackgroundTask:[self backgroundTaskID]];
  [self setBackgroundTaskID:UIBackgroundTaskInvalid];
}

#pragma mark - retry counts
- (NSUInteger)retryCountFromUserInfo:(NSDictionary *)theUserInfo
{
  NSNumber *count = [theUserInfo objectForKey:RETRY_KEY];
  return [count unsignedIntValue];
}

- (NSMutableDictionary *)userInfoWithRetryCount:(NSUInteger)theCount
                                   fromUserInfo:(NSDictionary *)theUserInfo
{
  NSMutableDictionary *newUserInfo = [theUserInfo mutableCopy];
  
  [newUserInfo setObject:[NSNumber numberWithUnsignedInt:theCount]
                  forKey:RETRY_KEY];
  return newUserInfo;
}

- (NSMutableDictionary *)userInfoWithIncreasedRetryCountBy:(NSInteger)theIncreaseValue
                                              fromUserInfo:(NSDictionary *)theUserInfo
{
  NSUInteger newRetryCount 
  = [self retryCountFromUserInfo:theUserInfo] + theIncreaseValue;
  
  return [self userInfoWithRetryCount:newRetryCount
                         fromUserInfo:theUserInfo];
}
@end