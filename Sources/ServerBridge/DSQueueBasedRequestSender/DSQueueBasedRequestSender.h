
#import <Foundation/Foundation.h>
#import "DSWebServiceFramework.h"
#import "DSAlertsSupportCode.h"

@class DSMessage;
@class DSWebServiceQueue;

typedef void (^request_successful_block_t)(id<DSWebServiceRequest> request, DSWebServiceResponse *response, ds_results_completion completion);
typedef void (^request_failed_block_t)(id<DSWebServiceRequest> request, DSMessage *errorMessage, ds_results_completion completion);

@interface DSQueueBasedRequestSender: NSObject<DSWebServiceRequestDelegate>
@property (strong, readonly) DSWebServiceQueue *queue;
/** @return array of id<DSWebServiceRequest> objects */
- (NSArray *)activeRequests;
- (NSInteger)requestCount;
@property (nonatomic, assign, getter=isSuspended) BOOL suspended;
@end

@interface DSQueueBasedRequestSender(Callbacks)
- (void)requestCountChanged;
@end
