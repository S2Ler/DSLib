
@import Foundation;
#import "DSWebServiceFramework.h"
#import "DSAlertsSupportCode.h"

NS_ASSUME_NONNULL_BEGIN

@class DSMessage;
@class DSWebServiceQueue;
@class DSMessageInterceptor;

typedef void (^request_successful_block_t)(id<DSWebServiceRequest> request,
                                            DSWebServiceResponse *response,
                                           __nullable ds_results_completion completion);
typedef void (^request_failed_block_t)(id<DSWebServiceRequest> request,
                                       DSMessage *__nullable errorMessage,
                                       __nullable ds_results_completion completion);

@interface DSQueueBasedRequestSender: NSObject<DSWebServiceRequestDelegate>
@property (strong, readonly) DSWebServiceQueue *queue;
/** @return array of id<DSWebServiceRequest> objects */
- (NSArray *)activeRequests;
- (nullable id<DSWebServiceRequest>)findActiveRequestPassingTest:(BOOL(^)(id<DSWebServiceRequest>))testBlock;
- (nullable id<DSWebServiceRequest>)activeRequestForParamsClass:(Class)paramsClass;
- (NSInteger)requestCount;
//- (BOOL)hasActiveRequest

@property (nonatomic, assign, getter=isSuspended) BOOL suspended;

+ (void)addMessageInterceptor:(DSMessageInterceptor *)interceptor;
+ (void)removeMessageInterceptor:(DSMessageInterceptor *)interceptor;

@end

@interface DSQueueBasedRequestSender(Callbacks)
- (void)requestCountChanged;
@end

NS_ASSUME_NONNULL_END
