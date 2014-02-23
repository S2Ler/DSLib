
#import <Foundation/Foundation.h>
#import "DSQueueBasedRequestSender.h"
#import "DSAlertsSupportCode.h"

@class DSWebServiceParams;

/** Requests with params where outputPath isn't nil will be always treated as succesful responses */
@interface DSQueueBasedRequestSender (Private)
- (id<DSWebServiceRequest>)sendRequestWithParams:(DSWebServiceParams *)params
                                      completion:(ds_results_completion)completion
                        requestSuccessfulHandler:(request_successful_block_t)requestSuccessfulHandler;

- (id<DSWebServiceRequest>)sendRequestWithParams:(DSWebServiceParams *)params
                                      completion:(ds_results_completion)completion;


- (id<DSWebServiceRequest>)sendRequestWithParams:(DSWebServiceParams *)params
                                      completion:(ds_results_completion)completion
                        requestSuccessfulHandler:(request_successful_block_t)requestSuccessfulHandler
                                        userInfo:(NSDictionary *)userInfo;

- (id<DSWebServiceRequest>)sendRequestWithParams:(DSWebServiceParams *)params
                                      completion:(ds_results_completion)completion
                        requestSuccessfulHandler:(request_successful_block_t)requestSuccessfulHandler
                            requestFailedHandler:(request_failed_block_t)requestFailedHandler
                                        userInfo:(NSDictionary *)userInfo;

- (id<DSWebServiceRequest>)sendRequestWithParams:(DSWebServiceParams *)params
                                      completion:(ds_results_completion)completion
                        requestSuccessfulHandler:(request_successful_block_t)requestSuccessfulHandler
                            requestFailedHandler:(request_failed_block_t)requestFailedHandler
                                        userInfo:(NSDictionary *)userInfo
                                   callbackQueue:(dispatch_queue_t)callbackQueue;

//- (id<DSWebServiceRequest>)sendRequestWithParams:(DSWebServiceParams *)params
//                                      completion:(ds_results_completion)completion
//                                   progressBlock:(request_progress_block)
//                        requestSuccessfulHandler:(request_successful_block_t)requestSuccessfulHandler
//                            requestFailedHandler:(request_failed_block_t)requestFailedHandler
//                                        userInfo:(NSDictionary *)userInfo
//                                   callbackQueue:(dispatch_queue_t)callbackQueue;


/** If completion is nil, return immidiately, otherwise wait all requests to finish. 
 Completion will be called on Main Thread. To have it called on other thread use 'cancelAllRequestsWithCompletion:queue: method
 */
- (void)cancelAllRequestsWithCompletion:(ds_completion_handler)completion;
- (void)cancelAllRequestsWithCompletion:(ds_completion_handler)completion queue:(dispatch_queue_t)queue;

@end

