
#pragma mark - include
#import "DSFakeWebServiceRequest.h"
#import "NSString+Encoding.h"
#import "NSString+Extras.h"
#import "DSMacros.h"
#import "DSFakeWebServiceRequestBehaviour.h"
#import "DSWebServiceResponse.h"
#import "NSError+DSWebService.h"

static NSString *cachedPlistName = nil;

@interface DSFakeWebServiceRequest()

@property (nonatomic, strong) NSString *fakeResponse;
@property (nonatomic, strong) DSFakeWebServiceRequestBehaviour *behaviour;
@property (nonatomic, strong) NSDictionary *plist;

//Emulating 
- (void)request_startRunning;
- (void)request_cancelRunning;
/** request_finishWithSuccess or request_finishWithError chose based on behaviour */
- (void)request_finish;
- (void)request_finishWithSuccess;
- (void)request_finishWithError;
@end

@implementation DSFakeWebServiceRequest
@synthesize plist = _plist;
@synthesize fakeResponse = _fakeResponse;
@synthesize behaviourName = _behaviourName;
@synthesize behaviour = _behaviour;
@synthesize userInfo = _userInfo;
@synthesize params = _params;
@synthesize delegate = _delegate;
@synthesize timeoutInterval = _timeoutInterval;
@synthesize POSTData = _POSTData;
@synthesize POSTDataPath = _POSTDataPath;
@synthesize POSTDataKey = _POSTDataKey;
@synthesize POSTDataFileName = _POSTDataFileName;
@synthesize runningInterval = _runningInterval;
@synthesize sendRawPOSTData = _sendRawPOSTData;

- (void)dealloc {
  [self request_cancelRunning];  
}

- (id)initWithPlist:(NSDictionary *)thePlist
{
  self = [super init];
  if (self) {
    _plist = thePlist;
    _runningInterval = 1.0;
  }
  return self;
}

+ (NSCache *)sharedCache
{
  DEFINE_SHARED_INSTANCE_USING_BLOCK(^{
    return [[NSCache alloc] init];
  });
}

+ (void)cacheRequestsPlist:(NSString *)thePlistName
{
  cachedPlistName = thePlistName;  
}

+ (NSDictionary *)cachedPlist
{
  NSDictionary *plist = [[self sharedCache] objectForKey:cachedPlistName];
  
  if (plist == nil) {
    plist = [cachedPlistName loadPlistFromBundle];
    [[self sharedCache] setObject:plist forKey:cachedPlistName];
  }
  
  return plist;
}

- (void)setUserInfo:(NSMutableDictionary *)userInfo
{
  if (userInfo != _userInfo) {
    if ([userInfo isKindOfClass:[NSMutableDictionary class]] == NO) {
      _userInfo = [userInfo mutableCopy];
    } else {
      _userInfo = userInfo;
    }
  }
}

- (NSMutableDictionary *)userInfo
{
  if (!_userInfo) {
    _userInfo = [NSMutableDictionary dictionary];
  }
  
  return _userInfo;
}

+ (DSFakeWebServiceRequest *)requestFromPlist:(NSDictionary *)thePlist
                            requestKeyInPlist:(NSString *)theRequestKey
{
  DSFakeWebServiceRequest *request = [[DSFakeWebServiceRequest alloc] initWithPlist:thePlist];

  NSDictionary *fakeRequest = [[thePlist objectForKey:@"requests"] objectForKey:theRequestKey];
  [request setFakeResponse:[fakeRequest objectForKey:@"response"]];

  NSString *paramsClassName = [[theRequestKey componentsSeparatedByString:@"_"] objectAtIndex:0];

  Class paramsClass = NSClassFromString(paramsClassName);
  [request setParamsClass:paramsClass];
  
  return request;  
}

+ (DSFakeWebServiceRequest *)requestFromPlistWithName:(NSString *)thePlistName
                                   responseKeyInPlist:(NSString *)theResponseKey
{
  NSDictionary *plist = [thePlistName loadPlistFromBundle];
  if (!plist) return nil;
  return [self requestFromPlist:plist requestKeyInPlist:theResponseKey];
}

+ (DSFakeWebServiceRequest *)requestFromCachedPlistForResponseKeyInPlist:(NSString *)theResponseKey
{
  NSDictionary *plist = [self cachedPlist];
  if (plist == nil) return nil;
  
  return [self requestFromPlist:plist requestKeyInPlist:theResponseKey];
}

- (void)setBehaviourName:(NSString *)behaviourName
{
  if (behaviourName != _behaviourName) {
    _behaviourName = behaviourName;
    [self setBehaviour:nil];
  }
}

- (DSFakeWebServiceRequestBehaviour *)behaviour
{
  if (_behaviour == nil) {
    _behaviour = [[DSFakeWebServiceRequestBehaviour alloc] initWithDefinition:
                  [[[self plist] objectForKey:@"behaviours"] objectForKey:[self behaviourName]]];
  }
  
  return _behaviour;
}

#pragma mark - connections
- (void)send
{
  if ([self behaviour] == nil) {
    [NSException raise:@"DSInternalInconsistencyException" 
                format:@"BehaviourName is missing or invalid: %@", [self behaviourName]];
    return;
  }

  [self start];
}

- (void)operationDidStart
{
  [self request_startRunning];
}

- (void)cancel
{
  [self request_cancelRunning];
}

- (BOOL)isRequestWithFunctionName:(NSString *)theFunctionName 
                       HTTPMethod:(DSWebServiceURLHTTPMethod)theHTTPMethod {
  return YES;
}

- (NSString *)functionName
{
  return nil;
}


#pragma mark - results
- (NSData *)responseData
{
  NSData *fakeResponseData = [[self fakeResponse] dataUsingEncoding:NSUTF8StringEncoding];
  return fakeResponseData;
}

- (DSWebServiceResponse *)response 
{
  DSWebServiceResponse *response
  = [DSWebServiceResponse responseWithData:[self responseData]];
  [response parse];
  
  return response;
}

- (DSWebServiceURL *)url
{
  return nil;
}

#pragma mark - Emulating
- (void)request_finish
{
  BOOL shouldFail = [[self behaviour] shouldFail];
  if (shouldFail) {
    [self request_finishWithError];
  }
  else {
    [self request_finishWithSuccess];
  }
}

- (void)request_startRunning
{
  NSLog(@"");
  [self performSelector:@selector(request_finish) withObject:nil afterDelay:[self runningInterval]];
}

- (void)request_cancelRunning
{
  NSLog(@"");
  [[self class] cancelPreviousPerformRequestsWithTarget:self
                                               selector:@selector(request_finish) 
                                                 object:nil];
  [super cancel];
}

- (void)request_finishWithSuccess
{
  if ([[self delegate] respondsToSelector:
       @selector(webServiceRequest:didEndLoadWithResponse:)]) 
  {
    NSLog(@"%@", [self response]);
    [[self delegate] webServiceRequest:self
                didEndLoadWithResponse:[self response]];
  }
  [self finishWithError:nil];
}

- (void)request_finishWithError
{
  if ([[self delegate] respondsToSelector:
                           @selector(webServiceRequest:didFailWithError:)])
  {
    NSError *error = [NSError errorWithDescription:[[self behaviour] errorMessage]
                                            domain:@"DSFakeWebServiceRequest"
                                              code:-1];
    NSLog(@"%@", [error localizedDescription]);
    [[self delegate] webServiceRequest:self didFailWithError:error];
    [self finishWithError:error];
  }
}

- (NSString *)description
{
  return [NSString stringWithFormat:@"fake_respone: %@", [self fakeResponse]];
}

//===========================================================
//  Keyed Archiving
//
//===========================================================
- (void)encodeWithCoder:(NSCoder *)encoder
{
  [encoder encodeBool:self.sendRawPOSTData forKey:@"sendRawPOSTData"];
  [encoder encodeObject:self.responseData forKey:@"responseData"];
  [encoder encodeObject:self.userInfo forKey:@"userInfo"];
  [encoder encodeObject:self.POSTData forKey:@"POSTData"];
  [encoder encodeObject:self.POSTDataPath forKey:@"POSTDataPath"];
  [encoder encodeObject:self.POSTDataKey forKey:@"POSTDataKey"];
  [encoder encodeObject:self.POSTDataFileName forKey:@"POSTDataFileName"];
  [encoder encodeDouble:self.timeoutInterval forKey:@"timeoutInterval"];
  [encoder encodeObject:self.url forKey:@"url"];
  [encoder encodeObject:self.params forKey:@"params"];
  [encoder encodeObject:NSStringFromClass([self paramsClass]) forKey:@"paramsClassName"];
}

- (id)initWithCoder:(NSCoder *)decoder
{
  self = [super init];
  if (self) {
    self.sendRawPOSTData = [decoder decodeBoolForKey:@"sendRawPOSTData"];
    self.userInfo = [decoder decodeObjectForKey:@"userInfo"];
    self.POSTData = [decoder decodeObjectForKey:@"POSTData"];
    self.POSTDataPath = [decoder decodeObjectForKey:@"POSTDataPath"];
    self.POSTDataKey = [decoder decodeObjectForKey:@"POSTDataKey"];
    self.POSTDataFileName = [decoder decodeObjectForKey:@"POSTDataFileName"];
    [self setTimeoutInterval:[decoder decodeDoubleForKey:@"timeoutInterval"]];
    self.params = [decoder decodeObjectForKey:@"params"];
    self.paramsClass = NSClassFromString([decoder decodeObjectForKey:@"paramsClassName"]);
  }
  return self;
}
@end
