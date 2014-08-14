#pragma mark - include
#import "DSWebServiceNetRequest.h"
#import "DSWebServiceParam.h"
#import "DSWebServiceURL.h"
#import "DSWebServiceResponse.h"
#import "NSData+OAdditions.h"
#import "NSNumber+DSAdditions.h"
#import "AFStreamingMultipartFormData.h"
#import "AFFunctions.h"

#define DEFAULT_TIMEOUT 30

#pragma mark - props
@interface DSWebServiceNetRequest ()<NSURLConnectionDelegate, NSURLConnectionDataDelegate>
{
  long long _expectedDownloadSize;
}

@property (nonatomic, retain) DSWebServiceURL *url;
@property (nonatomic, retain) NSURLConnection *connection;
@property (nonatomic, retain) NSOutputStream *outputStream;

@end

#pragma mark - private
@interface DSWebServiceNetRequest (Private)
@end

@implementation DSWebServiceNetRequest
@synthesize url = _url;
@synthesize userInfo = _userInfo;
@synthesize params = _params;
@synthesize connection = _connection;
@synthesize delegate = _delegate;
@synthesize timeoutInterval = _timeoutInterval;
@synthesize POSTData = _POSTData;
@synthesize POSTDataPath = _POSTDataPath;
@synthesize POSTDataKey = _POSTDataKey;
@synthesize POSTDataFileName = _POSTDataFileName;
@synthesize sendRawPOSTData = _sendRawPOSTData;

#pragma mark - init
- (id)initWithServer:(DSWebServiceURL *)theWebServiceURL
              params:(id<DSWebServiceParam>)theParams
            userInfo:(NSMutableDictionary *)theUserInfo
{
  self = [super init];

  if (self) {
    [self setUrl:theWebServiceURL];
    [self setParams:theParams];

    if ([theUserInfo isKindOfClass:[NSMutableDictionary class]] == NO) {
      _userInfo = [theUserInfo mutableCopy];
    }
    else {
      _userInfo = theUserInfo;
    }

    if (_userInfo == nil) {
      _userInfo = [NSMutableDictionary dictionary];
    }

    [self setTimeoutInterval:DEFAULT_TIMEOUT];
  }

  return self;
}

- (void)setOutputPath:(NSString *)outputPath
{
  NSAssert(![self outputPath], @"Shouldn't happen due to logic");
  
  if (outputPath) {
    [[self userInfo] setValue:outputPath forKey:@"__outputPath"];
    NSAssert(![self outputStream], @"Shouldn't happen due to logic");
    [self setOutputStream:[[NSOutputStream alloc] initToFileAtPath:outputPath append:NO]];
  }
}

- (NSString *)outputPath
{
  return [[self userInfo] valueForKey:@"__outputPath"];
}

- (NSData *)responseData
{
  return [[self outputStream] propertyForKey:NSStreamDataWrittenToMemoryStreamKey];;
}

- (id)initWithServer:(DSWebServiceURL *)theWebServiceURL
              params:(id<DSWebServiceParam>)theParams
{
  return [self initWithServer:theWebServiceURL
                       params:theParams
                     userInfo:nil];
}

+ (id)requestWithServer:(DSWebServiceURL *)theWebServiceURL
                 params:(id<DSWebServiceParam>)theParams
               userInfo:(NSMutableDictionary *)theUserInfo
{
  DSWebServiceNetRequest *request
    = [[DSWebServiceNetRequest alloc] initWithServer:theWebServiceURL
                                              params:theParams
                                            userInfo:theUserInfo];
  return request;
}

+ (id)requestWithServer:(DSWebServiceURL *)theWebServiceURL
                 params:(id<DSWebServiceParam>)theParams
{
  DSWebServiceNetRequest *request
    = [[DSWebServiceNetRequest alloc] initWithServer:theWebServiceURL
                                              params:theParams];
  return request;
}

- (void)setUserInfo:(NSMutableDictionary *)userInfo
{
  if (_userInfo) {
    [_userInfo addEntriesFromDictionary:userInfo];
  }
  else {
    _userInfo = [userInfo mutableCopy];
  }
}

- (NSMutableDictionary *)userInfo
{
  if (!_userInfo) {
    _userInfo = [NSMutableDictionary dictionary];
  }

  return _userInfo;
}

#pragma mark - public
#pragma mark - public
- (NSMutableData *)postDataForRequest:(NSMutableURLRequest *)request
{
  NSString *boundary
  = @"----WebKitFormBoundaryYA9vSekClgZaHxyb";
  
  NSString *contentType
  = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", boundary];
  
  [request addValue:contentType
 forHTTPHeaderField:@"Content-Type"];
  
  NSString *boundaryString
  = [NSString stringWithFormat:@"\r\n--%@\r\n", boundary];
  
  NSString *boundaryStringFinal
  = [NSString stringWithFormat:@"\r\n--%@--\r\n", boundary];
  
  NSMutableData *postData = [NSMutableData data];
  
  [postData appendData:[boundaryString dataUsingEncoding:NSUTF8StringEncoding]];
  
  NSString *formDataHeader = nil;
  
  if ([self POSTDataFileName]) {
    if ([self POSTDataKey]) {
      formDataHeader
      = [NSString stringWithFormat:
         @"Content-Disposition: form-data; name=\"%@\"; filename=\"%@\"\r\nContent-Type: application/octet-stream\r\n\r\n",
         [self POSTDataKey], [self POSTDataFileName]];
    }
    else {
      formDataHeader
      = [NSString stringWithFormat:
         @"Content-Disposition: form-data; name=\"file\"; filename=\"%@\"\r\nContent-Type: application/octet-stream\r\n\r\n",
         [self POSTDataFileName]];
    }
  }
  else if ([self POSTDataKey]) {
    formDataHeader = [NSString stringWithFormat:
                      @"Content-Disposition: form-data; name=\"%@\"\r\n\r\n",
                      [self POSTDataKey]];
  }
  else {
    formDataHeader
    = [NSString stringWithFormat:
       @"Content-Disposition: form-data; name=\"file\"; filename=\"%@\"\r\nContent-Type: application/octet-stream\r\n\r\n",
       @"POST.dat"];
  }
  
  [postData appendData:
   [formDataHeader dataUsingEncoding:NSUTF8StringEncoding]];
  
  NSData *mainPostData = nil;
  
  if ([self POSTData]) {
    mainPostData = [self POSTData];
  }
  else if ([self POSTDataPath]) {
    mainPostData = [NSData dataWithContentsOfMappedFile:[self POSTDataPath]];
  }
  
  [postData appendData:mainPostData];
  [postData appendData:
   [boundaryStringFinal dataUsingEncoding:NSUTF8StringEncoding]];
  return postData;
}

- (void)configureFormData:(AFStreamingMultipartFormData *)formData
{
  if (![self POSTDataKey]) {
    [self setPOSTDataKey:@"file"];
  }
  
  if ([self POSTData]) {
    [formData appendPartWithFormData:[self POSTData] name:[self POSTDataKey]];
#ifdef DEBUG
    NSLog(@"Form Data: %@", [[NSString alloc] initWithData:[self POSTData] encoding:NSUTF8StringEncoding]);
#endif
  }
  
  if ([self POSTDataPath]) {
    if (![self POSTDataFileName]) {
      [self setPOSTDataFileName:@"file"];
    }
    NSURL *fileURL = [NSURL fileURLWithPath:[self POSTDataPath]];
    NSString *fileName = [self POSTDataFileName];
    NSString *mimeType = AFContentTypeForPathExtension([fileURL pathExtension]);
    
    [formData appendPartWithFileURL:fileURL name:@"file" fileName:fileName mimeType:mimeType error:nil];
  }
}

- (void)send
{
  [self start];
}

- (void)operationDidStart
{
  [super operationDidStart];

  [[self url] applyParams:_params];

  if ([[self url] HTTPMethod] == DSWebServiceURLHTTPMethodPOST &&
    [self POSTData] == nil && ![self POSTDataPath]) {
    [self setPOSTData:[[self url] paramsDataForPOST]];
  }
  NSString *urlString = [[self url] urlString];

  NSURL *nsURL = [NSURL URLWithString:urlString];

  NSMutableURLRequest *request = nil;

  if ([self POSTData] == nil && [self POSTDataPath] == nil) {
    request = [NSMutableURLRequest requestWithURL:nsURL
                                      cachePolicy:NSURLRequestReloadIgnoringLocalCacheData
                                  timeoutInterval:_timeoutInterval];
  }
  else {
    request = [[NSMutableURLRequest alloc] init];
    
    [request setURL:nsURL];
    
    NSData *postData = nil;
    if ([self sendRawPOSTData] == YES) {
      [request setHTTPBody:[self POSTData]];
      NSString *dataLength = [NSString stringWithFormat:@"%lu", (unsigned long)[postData length]];
      
      [request addValue:dataLength forHTTPHeaderField:@"Content-Length"];
    }
    else {
      AFStreamingMultipartFormData *formData
      = [[AFStreamingMultipartFormData alloc] initWithURLRequest:request
                                                  stringEncoding:NSUTF8StringEncoding];
      [self configureFormData:formData];
      request = [formData requestByFinalizingMultipartFormData];
    }
    
    [request setTimeoutInterval:DEFAULT_TIMEOUT];
    [request setCachePolicy:NSURLRequestUseProtocolCachePolicy];
  }

  [request setHTTPMethod:
             NSStringFromDSWebServiceURLHTTPMethod([[self url] HTTPMethod])];

  NSString *logString = nil;

  if ([[self url] HTTPMethod] == DSWebServiceURLHTTPMethodPOST) {
    NSString *POSTBodyString = [[NSString alloc] initWithData:[request HTTPBody]
                                          encoding:NSUTF8StringEncoding];
    logString = [NSString stringWithFormat:@"\nURL:\t%@\nHTTPBody: %@",
                                           urlString, POSTBodyString];
  }
  else {
    logString = [NSString stringWithFormat:@"\nURL:\t%@", urlString];
  }

  if (logString) {
    NSLog(@"%@", logString);
  }


  NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request
                                                                delegate:self
                                                        startImmediately:NO];
  [self setConnection:connection];
  for (NSString *mode in self.actualRunLoopModes) {
    [self.connection scheduleInRunLoop:[NSRunLoop currentRunLoop]
                     forMode:mode];
  }

#if DEBUG_COOKIES
  NSArray *allCookies = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies];
  for (NSHTTPCookie *c in allCookies) {
    NSString *cc = [[c value] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSLog(@"Cookie Value: %@\nFull Dumb:%@", cc, c);
  }
#endif
  
  [self.connection start];
}

- (void)operationWillFinish
{
  [super operationWillFinish];

  [[self connection] cancel];
  [self setConnection:nil];
}

- (void)finishWithError:(NSError *)error
{
  [super finishWithError:error];
}


- (DSWebServiceResponse *)response
{
  DSWebServiceResponse *response = nil;
  if ([self outputPath]) {
    response = [DSWebServiceResponse responseWithPath:[self outputPath]];
  }
  if ([self responseData]) {
    response = [DSWebServiceResponse responseWithData:[self responseData]];
  }

  return response;
}

- (BOOL)isRequestWithFunctionName:(NSString *)theFunctionName
                       HTTPMethod:(DSWebServiceURLHTTPMethod)theHTTPMethod
{
  return ([[[self url] functionName] isEqualToString:theFunctionName] &&
    [[self url] HTTPMethod] == theHTTPMethod);
}

- (NSString *)functionName
{
  return [[self url] functionName];
}

#pragma mark NSURLConnection delegate methods
- (void)connection:(NSURLConnection *)connection
didReceiveResponse:(NSURLResponse *)response
{
  if (![self outputStream]) {
    [self setOutputStream:[[NSOutputStream alloc] initToMemory]];
  }
  [[self outputStream] open];
  
  _expectedDownloadSize = [response expectedContentLength];

  if ([[self delegate]
             respondsToSelector:
               @selector(webServiceRequest:didReceiveResponseWithExpectedDownloadSize:)]) {
    [[self delegate]     webServiceRequest:self
didReceiveResponseWithExpectedDownloadSize:_expectedDownloadSize];
  }
}

- (void)connection:(NSURLConnection *)connection
    didReceiveData:(NSData *)data
{
  NSUInteger length = [data length];
  while (YES) {
    NSInteger totalNumberOfBytesWritten = 0;
    if ([self.outputStream hasSpaceAvailable]) {
      const uint8_t *dataBuffer = (uint8_t *)[data bytes];
      
      NSInteger numberOfBytesWritten = 0;
      while (totalNumberOfBytesWritten < (NSInteger)length) {
        numberOfBytesWritten = [self.outputStream write:&dataBuffer[(NSUInteger)totalNumberOfBytesWritten] maxLength:(length - (NSUInteger)totalNumberOfBytesWritten)];
        if (numberOfBytesWritten == -1) {
          break;
        }
        
        totalNumberOfBytesWritten += numberOfBytesWritten;
      }
      
      break;
    }
    
    if (self.outputStream.streamError) {
      [self.connection cancel];
      [self performSelector:@selector(connection:didFailWithError:)
                 withObject:self.connection
                 withObject:self.outputStream.streamError];
      return;
    }
  }
  
  if ([[self delegate] respondsToSelector:@selector(webServiceRequest:didReceiveSize:expectedReceiveSize:)]) {
    NSNumber *offset = [[self outputStream] propertyForKey:NSStreamFileCurrentOffsetKey];
    [[self delegate] webServiceRequest:self
                        didReceiveSize:[offset fileSizeValue]
                   expectedReceiveSize:_expectedDownloadSize];
  }
}

- (void)connection:(NSURLConnection *)conn
  didFailWithError:(NSError *)error
{
  [[self outputStream] close];
  [[NSFileManager defaultManager] removeItemAtPath:[self outputPath]
                                             error:nil];
  
  NSLog(@"Connection error code: {%li}\nDescription: {%@}",
  (long)[error code], [error localizedDescription]);

  [self setConnection:nil];

  if ([[self delegate] respondsToSelector:
    @selector(webServiceRequest:didFailWithError:)]) {
    [[self delegate] webServiceRequest:self
                      didFailWithError:error];
  }

  [self finishWithError:error];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
  DSWebServiceResponse *webServiceResponse = [self response];

  NSLog(@"\nURL: %@\nParams: %@\nServer Response: %@",
        [self url],
        [self params],
        [[NSString alloc] initWithData:[self responseData]
                              encoding:NSStringEncodingConversionExternalRepresentation]);

  if ([[self delegate] respondsToSelector:
    @selector(webServiceRequest:didEndLoadWithResponse:)]) {
    [[self delegate] webServiceRequest:self
                didEndLoadWithResponse:webServiceResponse];
  }

  [self setConnection:nil];

  [[self outputStream] close];
  [self finishWithError:nil];  
}

- (NSInputStream *)connection:(NSURLConnection *)connection needNewBodyStream:(NSURLRequest *)request
{
  AFStreamingMultipartFormData *formData
  = [[AFStreamingMultipartFormData alloc] initWithStringEncoding:NSUTF8StringEncoding];

  [self configureFormData:formData];
  NSInputStream *inputStream = [formData createInputStream];
  return inputStream;
}

#pragma mark - HTTPS workaround
- (BOOL)                   connection:(NSURLConnection *)connection
canAuthenticateAgainstProtectionSpace:(NSURLProtectionSpace *)protectionSpace
{
  return [protectionSpace.authenticationMethod
    isEqualToString:NSURLAuthenticationMethodServerTrust];
}

- (void)               connection:(NSURLConnection *)connection
didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge
{
  NSURLCredential *credentials = [NSURLCredential credentialForTrust:
                                                    [[challenge protectionSpace]
                                                                serverTrust]];
  [[challenge sender] useCredential:credentials
         forAuthenticationChallenge:challenge];

  [[challenge sender]
              continueWithoutCredentialForAuthenticationChallenge:challenge];
}

#pragma mark - request userinfo
- (NSString *)description
{
  NSString *result = [[self params] description];
  return result;
}

@end

//&& ![self POSTDataPath]


