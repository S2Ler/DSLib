
@import Foundation;
#import "DSQueueBasedRequestSender.h"
#import "DSAlertsSupportCode.h"

NS_ASSUME_NONNULL_BEGIN

@class DSWebServiceParams;
@class DSQueueRecurrentRequestPolicy;

/** Requests with params where outputPath isn't nil will be always treated as succesful responses */
@interface DSQueueBasedRequestSender (Private)
@property (nonatomic, strong) dispatch_queue_t workingQueue;

- (id<DSWebServiceRequest>)sendRequestWithParams:(DSWebServiceParams *)params
                                      completion:(ds_results_completion)completion
                        requestSuccessfulHandler:(nullable request_successful_block_t)requestSuccessfulHandler;
- (id<DSWebServiceRequest>)sendRequestWithParams:(DSWebServiceParams *)params
                                      completion:(ds_results_completion)completion
                        requestSuccessfulHandler:(nullable request_successful_block_t)requestSuccessfulHandler
                                   callbackQueue:(nullable dispatch_queue_t)callbackQueue;

- (id<DSWebServiceRequest>)sendRequestWithParams:(DSWebServiceParams *)params
                                      completion:(ds_results_completion)completion;


- (id<DSWebServiceRequest>)sendRequestWithParams:(DSWebServiceParams *)params
                                      completion:(ds_results_completion)completion
                        requestSuccessfulHandler:(nullable request_successful_block_t)requestSuccessfulHandler
                                        userInfo:(nullable NSDictionary *)userInfo;

- (id<DSWebServiceRequest>)sendRequestWithParams:(DSWebServiceParams *)params
                                      completion:(ds_results_completion)completion
                        requestSuccessfulHandler:(nullable request_successful_block_t)requestSuccessfulHandler
                            requestFailedHandler:(nullable request_failed_block_t)requestFailedHandler
                                        userInfo:(nullable NSDictionary *)userInfo;

- (id<DSWebServiceRequest>)sendRequestWithParams:(DSWebServiceParams *)params
                                      completion:(ds_results_completion)completion
                        requestSuccessfulHandler:(nullable request_successful_block_t)requestSuccessfulHandler
                            requestFailedHandler:(nullable request_failed_block_t)requestFailedHandler
                                        userInfo:(nullable NSDictionary *)userInfo
                                   callbackQueue:(nullable dispatch_queue_t)callbackQueue;

- (void)addRecurrentRequestWithParams:(DSWebServiceParams *)params
                           completion:(ds_results_completion)completion
             requestSuccessfulHandler:(nullable request_successful_block_t)requestSuccessfulHandler
                 requestFailedHandler:(nullable request_failed_block_t)requestFailedHandler
                             userInfo:(nullable NSDictionary *)userInfo
                        callbackQueue:(nullable dispatch_queue_t)callbackQueue
                      recurrentPolicy:(DSQueueRecurrentRequestPolicy *)policy
                           requestKey:(NSString *)requestKey;


/** If completion is nil, return immidiately, otherwise wait all requests to finish.
 Completion will be called on Main Thread. To have it called on other thread use 'cancelAllRequestsWithCompletion:queue: method
 */
- (void)cancelAllRequestsWithCompletion:(ds_completion_handler)completion;
- (void)cancelAllRequestsWithCompletion:(ds_completion_handler)completion queue:(dispatch_queue_t)queue;
- (void)removeAllRecurrentRequests;

@end

NS_ASSUME_NONNULL_END