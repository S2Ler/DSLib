
#import <Foundation/Foundation.h>
#import "DSWebServiceFramework.h"
#import "DSWebServiceParams.h"

@interface DSWebServiceRequestsFactory: NSObject
/** Default shouldFail = NO, \see next method*/
+ (id<DSWebServiceRequest>)requestWithParams:(DSWebServiceParams *)theParams;
/** \param shouldFail is only for fake requests */
+ (id<DSWebServiceRequest>)requestWithParams:(DSWebServiceParams *)theParams shouldFail:(BOOL)fail;
@end
