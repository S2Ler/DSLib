
@import Foundation;

typedef enum __DSWebServiceURLHTTPMethod
{
  DSWebServiceURLHTTPMethodGET = 2,
  DSWebServiceURLHTTPMethodDELETE,
  DSWebServiceURLHTTPMethodPOST

} DSWebServiceURLHTTPMethod;

NSString *NSStringFromDSWebServiceURLHTTPMethod(DSWebServiceURLHTTPMethod method);