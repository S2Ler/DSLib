
#import "DSWebServiceRequest.h"
#import "QRunLoopOperation.h"

/** At the moment POST requests is not supported */
@interface DSFakeWebServiceRequest : QRunLoopOperation<DSWebServiceRequest>

/** See RRFakeWebServiceRequests.plist behaviours section. */
@property (nonatomic, strong) NSString *behaviourName; 
/** How much seconds request will run before finish or fail.
 Default: 1sec*/
@property (nonatomic, assign) NSTimeInterval runningInterval;
@property (nonatomic, strong) Class paramsClass;

+ (void)cacheRequestsPlist:(NSString *)thePlistName;

/** theResponseKey = [ParmsClass]_[success|failure]
Don't use '_' in ParamsClass */
+ (DSFakeWebServiceRequest *)requestFromPlistWithName:(NSString *)thePlistName
                                   responseKeyInPlist:(NSString *)theResponseKey;
+ (DSFakeWebServiceRequest *)requestFromCachedPlistForResponseKeyInPlist:(NSString *)theResponseKey;
@end
