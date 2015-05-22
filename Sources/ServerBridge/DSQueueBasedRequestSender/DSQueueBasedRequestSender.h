
@import Foundation;
#import "DSWebServiceFramework.h"
#import "DSAlertsSupportCode.h"

@class DSMessage;
@class DSWebServiceQueue;
@class DSMessageInterceptor;

typedef void (^request_successful_block_t)(__nonnull id<DSWebServiceRequest> request,
                                            DSWebServiceResponse * __nonnull response,
                                           __nullable ds_results_completion completion);
typedef void (^request_failed_block_t)(__nonnull id<DSWebServiceRequest> request,
                                       DSMessage *__nullable errorMessage,
                                       __nullable ds_results_completion completion);

@interface DSQueueBasedRequestSender: NSObject<DSWebServiceRequestDelegate>
@property (strong, readonly, nonnull) DSWebServiceQueue *queue;
/** @return array of id<DSWebServiceRequest> objects */
- (nonnull NSArray *)activeRequests;
- (nullable id<DSWebServiceRequest>)findActiveRequestPassingTest:(nonnull BOOL(^)(__nonnull id<DSWebServiceRequest>))testBlock;
- (nullable id<DSWebServiceRequest>)activeRequestForParamsClass:(nonnull Class)paramsClass;
- (NSInteger)requestCount;
//- (BOOL)hasActiveRequest

@property (nonatomic, assign, getter=isSuspended) BOOL suspended;

+ (void)addMessageInterceptor:(nonnull DSMessageInterceptor *)interceptor;
+ (void)removeMessageInterceptor:(nonnull DSMessageInterceptor *)interceptor;

@end

@interface DSQueueBasedRequestSender(Callbacks)
- (void)requestCountChanged;
@end
