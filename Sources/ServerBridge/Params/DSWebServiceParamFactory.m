
#import "DSWebServiceParamFactory.h"
#import "DSWebServiceParam.h"
#import "DSWebServiceStringParam.h"
#import "DSWebServiceArrayParam.h"
#import "DSWebServiceCompositeParams.h"

@implementation DSWebServiceParamFactory
+ (id<DSWebServiceParam>)paramWithType:(DSWebServiceParamType)theType
{
  id<DSWebServiceParam> param = nil;
  
  switch (theType) {
    case DSWebServiceParamTypeString:
      param = [[DSWebServiceStringParam alloc] init];
      break;
    case DSWebServiceParamTypeArray:
      param = [[DSWebServiceArrayParam alloc] init];
      break;
    case DSWebServiceParamTypeDictionary:
      param = [[DSWebServiceCompositeParams alloc] init];
      break;
    default:
      NSAssert(FALSE, @"Unsupported param type: %d", theType);
      break;
  }
  
  return param;
}
@end
