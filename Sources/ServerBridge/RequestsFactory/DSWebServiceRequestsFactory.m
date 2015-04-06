
#pragma mark - include
#import "DSWebServiceRequestsFactory.h"
#import "DSWebServiceFunctions.h"
#import "NSDate+OAddittions.h"
#import "DSWebServiceConfiguration.h"
#import "DSFakeWebServiceRequest.h"

@implementation DSWebServiceRequestsFactory
+ (void)fillParam:(id)createdParam
     withSubValue:(id)subValue
              key:(NSString *)key
         paramIdx:(NSUInteger)paramIdx
         paramName:(NSString *)paramName
{
  if (!key) {
    key = [NSString stringWithFormat:@"%@[%lu]", paramName, (unsigned long)paramIdx];
  }
  
  if ([subValue isKindOfClass:[NSDictionary class]]) {
    id<DSWebServiceParam> subParams = [self paramsFromValues:subValue embeddedParams:nil];
    [createdParam addParam:subParams forParamName:key];
  }
  else if ([subValue isKindOfClass:[NSString class]]) {
    [createdParam addStringValue:subValue forParamName:key];
  }
  else if ([subValue isKindOfClass:[NSDate class]]) {
    NSString *datetimeString = [(NSDate *)subValue webServiceDateString];
    [createdParam addStringValue:datetimeString forParamName:key];
  }
  else if ([subValue isKindOfClass:[NSURL class]]) {
    [createdParam addStringValue:[subValue absoluteString] forParamName:key];
  }
  else {
    NSString *stringValue = [NSString stringWithFormat:@"%@", subValue];
    [createdParam addStringValue:stringValue forParamName:key];
  }
}

+ (id<DSWebServiceParam>)paramsFromValues:(NSDictionary *)theValues
                           embeddedParams:(NSArray *)theEmbeddedParams
{
  NSArray *paramNames = [theValues allKeys];
  id<DSWebServiceParam> params = [DSWebServiceParamFactory paramWithType:DSWebServiceParamTypeRoot];
  NSUInteger paramIdx = 0;
  for (NSString *paramName in paramNames) {
    id value = [theValues objectForKey:paramName];
    id<DSWebServiceParam> createdParam = nil;

    if ([value isKindOfClass:[NSString class]]) {
      createdParam = [params addStringValue:value forParamName:paramName];
    }
    else if ([value isKindOfClass:[NSDate class]]) {
      NSString *datetimeString = [(NSDate *)value webServiceDateString];
      createdParam = [params addStringValue:datetimeString forParamName:paramName];
    }
    else if ([value isKindOfClass:[NSURL class]]) {
      createdParam = [params addStringValue:[value absoluteString] forParamName:paramName];
    }
    else if ([value isKindOfClass:[NSArray class]]) {
      createdParam = [DSWebServiceParamFactory paramWithType:DSWebServiceParamTypeArray];
      for (id subValue in (NSArray *)value) {
        [self fillParam:createdParam withSubValue:subValue key:nil paramIdx:paramIdx paramName:paramName];
      }
      [params addParam:createdParam forParamName:paramName];
    }
    else if ([value isKindOfClass:[NSDictionary class]]) {
      createdParam = [DSWebServiceParamFactory paramWithType:DSWebServiceParamTypeDictionary];
      for (NSString *key in [(NSDictionary *)value allKeys]) {
        id subValue = [value valueForKey:key];
        [self fillParam:createdParam withSubValue:subValue key:key paramIdx:paramIdx paramName:paramName];
      }
      [params addParam:createdParam forParamName:paramName];
    }
    else {
      NSString *stringValue = [NSString stringWithFormat:@"%@", value];
      createdParam = [params addStringValue:stringValue forParamName:paramName];
    }

    if ([theEmbeddedParams containsObject:paramName]) {
      NSInteger paramEmbeddedIndex = [theEmbeddedParams indexOfObject:paramName];
      [createdParam setEmbeddedIndex:paramEmbeddedIndex];
    }
    
    paramIdx++;
  }

  return params;
}

+ (id<DSWebServiceRequest>)requestWithParams:(DSWebServiceParams *)theParams
{
   return [self requestWithParams:theParams shouldFail:NO];
}

+ (id<DSWebServiceRequest>)requestWithParams:(DSWebServiceParams *)theParams shouldFail:(BOOL)fail
{
  if (![[DSWebServiceConfiguration sharedInstance] isFactoryShouldGenerateFakeRequests]) {
    NSString *functionName = [theParams functionName];
    DSWebServiceURLHTTPMethod HTTPMethod = [theParams HTTPMethod];
    BOOL isHTTPSOnlyParams = [[DSWebServiceFunctions sharedInstance] isHTTPSForcedForParams:theParams];
    DSWebServiceURL *url = [DSWebServiceURL urlWithHTTPMethod:HTTPMethod
                                                 functionName:functionName
                                                   forceHTTPS:isHTTPSOnlyParams
                                              customServerURL:[theParams customServerURL]];
    [url setEmbedParamsInURLForPOSTRequest:[theParams embedParamsInURLForPOSTRequest]];

    NSDictionary *paramValues = [theParams allParams];
    NSArray *paramsEmbeddedInURL = [theParams paramsEmbeddedInURL];
    id<DSWebServiceParam> params = [self paramsFromValues:paramValues
                                           embeddedParams:paramsEmbeddedInURL];

    DSWebServiceNetRequest *request = [DSWebServiceNetRequest requestWithServer:url params:params];
    [request setOutputPath:[theParams outputPath]];
    [request setPOSTDataPath:[theParams POSTDataPath]];
    [request setRunLoopThread:[self networkRequestThread]];
    [request setPOSTDataFileName:[theParams POSTDataFileName]];
    if ([theParams timeoutInterval]) {
      [request setTimeoutInterval:[theParams timeoutInterval]];
    }
    [request setSendRawPOSTData:NO];
    [request setPOSTDataKey:@"json_request"];

    return request;
  }
  else {//FakeRequests
    NSString *paramsClassName = NSStringFromClass([theParams class]);
    NSString *suffix = nil;
    if (fail) {
      suffix = @"_failure";
    }
    else {
      suffix = @"_success";
    }
    NSString *fakeRequestKey = [NSString stringWithFormat:@"%@%@", paramsClassName, suffix];
    id<DSWebServiceRequest> request = [DSFakeWebServiceRequest requestFromCachedPlistForResponseKeyInPlist:fakeRequestKey];
    return request;
  }
}

#pragma mark - request thread
+ (void)networkRequestThreadEntryPoint:(id)__unused object {
  @autoreleasepool {
    [[NSThread currentThread] setName:@"DSWebService"];
    
    NSRunLoop *runLoop = [NSRunLoop currentRunLoop];
    [runLoop addPort:[NSMachPort port] forMode:NSDefaultRunLoopMode];
    [runLoop run];
  }
}

+ (NSThread *)networkRequestThread {
  static NSThread *_networkRequestThread = nil;
  static dispatch_once_t oncePredicate;
  dispatch_once(&oncePredicate, ^{
    _networkRequestThread = [[NSThread alloc] initWithTarget:self selector:@selector(networkRequestThreadEntryPoint:) object:nil];
    [_networkRequestThread start];
  });
  
  return _networkRequestThread;
}

@end
