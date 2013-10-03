
#import <Foundation/Foundation.h>
#import "DSWebServiceParam.h"

@interface DSWebServiceParamFactory : NSObject
+ (id<DSWebServiceParam>)paramWithType:(DSWebServiceParamType)theType;
@end
