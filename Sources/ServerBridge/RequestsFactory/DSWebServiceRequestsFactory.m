
#pragma mark - include
#import "DSWebServiceRequestsFactory.h"
#import "NSDate+OAddittions.h"
#import "DSWebServiceConfiguration.h"
#import "DSFakeWebServiceRequest.h"

@implementation DSWebServiceRequestsFactory
+ (id<DSWebServiceParam>)paramsFromValues:(NSDictionary *)theValues
                           embeddedParams:(NSArray *)theEmbeddedParams
{
  NSArray *paramNames = [theValues allKeys];
  id<DSWebServiceParam>
    params = [DSWebServiceParamFactory paramWithType:DSWebServiceParamTypeRoot];

  for (NSString *paramName in paramNames) {
    id value = [theValues objectForKey:paramName];
    id<DSWebServiceParam> createdParam = nil;

    if ([value isKindOfClass:[NSString class]]) {
      createdParam = [params addStringValue:value forParamName:paramName];
    }
    else if ([value isKindOfClass:[NSDate class]]) {
      NSString *datetimeString = [(NSDate *)value webServiceDateString];
      createdParam = [params addStringValue:datetimeString
                               forParamName:paramName];
    }
    else if ([value isKindOfClass:[NSArray class]]) {
      createdParam = [DSWebServiceParamFactory paramWithType:DSWebServiceParamTypeArray];
      for (id subValue in (NSArray *)value) {
        if ([subValue isKindOfClass:[NSDictionary class]]) {
          id<DSWebServiceParam> subParams = [self paramsFromValues:subValue embeddedParams:nil];
          [createdParam addParam:subParams forParamName:nil];
        }
        else if ([subValue isKindOfClass:[NSString class]]) {
          [createdParam addStringValue:subValue forParamName:nil];
        }
        else if ([subValue isKindOfClass:[NSDate class]]) {
          NSString *datetimeString = [(NSDate *)subValue webServiceDateString];
          [createdParam addStringValue:datetimeString forParamName:nil];
        }
        else {
          NSString *stringValue = [NSString stringWithFormat:@"%@", subValue];
          [createdParam addStringValue:stringValue forParamName:nil];
        }
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
    DSWebServiceURL *url = [DSWebServiceURL urlWithHTTPMethod:HTTPMethod
                                                 functionName:functionName];

    NSDictionary *paramValues = [theParams allParams];
    NSArray *paramsEmbeddedInURL = [theParams paramsEmbeddedInURL];
    id<DSWebServiceParam> params = [self paramsFromValues:paramValues
                                           embeddedParams:paramsEmbeddedInURL];

    id<DSWebServiceRequest> request = [DSWebServiceNetRequest requestWithServer:url params:params];
    [request setSendRawPOSTData:NO];
    [request setPOSTDataKey:@"key"];
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


@end
