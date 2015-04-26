
@import Foundation;
#import "DSWebServiceFramework.h"
#import "DSAlertsSupportCode.h"

@class DSMessage;
@class DSWebServiceQueue;
@class DSMessageInterceptor;

typedef void (^request_successful_block_t)(id<DSWebServiceRequest> request, DSWebServiceResponse *response, ds_results_completion completion);
typedef void (^request_failed_block_t)(id<DSWebServiceRequest> request, DSMessage *errorMessage, ds_results_completion completion);

@interface DSQueueBasedRequestSender: NSObject<DSWebServiceRequestDelegate>
@property (strong, readonly) DSWebServiceQueue *queue;
/** @return array of id<DSWebServiceRequest> objects */
- (NSArray *)activeRequests;
- (id<DSWebServiceRequest>)activeRequestForParamsClass:(Class)paramsClass;
- (NSInteger)requestCount;
//- (BOOL)hasActiveRequest

@property (nonatomic, assign, getter=isSuspended) BOOL suspended;

+ (void)addMessageInterceptor:(DSMessageInterceptor *)interceptor;
+ (void)removeMessageInterceptor:(DSMessageInterceptor *)interceptor;

@end

@interface DSQueueBasedRequestSender(Callbacks)
- (void)requestCountChanged;
@end
