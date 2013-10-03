
#import "DSWebServiceURLHTTPMethod.h"


NSString *NSStringFromDSWebServiceURLHTTPMethod(DSWebServiceURLHTTPMethod method)
{
  switch (method) {
    case DSWebServiceURLHTTPMethodDELETE:
      return @"DELETE";
    case DSWebServiceURLHTTPMethodGET:
      return @"GET";
    case DSWebServiceURLHTTPMethodPOST:
      return @"POST";
    default: return nil;
  }
}