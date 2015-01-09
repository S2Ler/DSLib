
@import Foundation;
#import "DSWebServiceParam.h"

@interface DSWebServiceParamFactory : NSObject
+ (id<DSWebServiceParam>)paramWithType:(DSWebServiceParamType)theType;
@end
