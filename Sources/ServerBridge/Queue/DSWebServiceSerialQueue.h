
#import <Foundation/Foundation.h>
#import "DSWebServiceRequestDelegate.h"

@class DSWebServiceSerialQueue;
@class DSWebServiceNetRequest;

typedef void (^WebServiceQueueHandler)
(DSWebServiceSerialQueue *queue,
 id<DSWebServiceRequest> request,
 DSWebServiceResponse *response,
 NSError *error);


/**
 Queue is serial - i.e. requests are being proceeded on by one
 Queue works on main queue. 
 But request are sent in the background. */
@interface DSWebServiceSerialQueue : NSObject
<
DSWebServiceRequestDelegate
>

/** If a request failed, the queue tries to send the request repeatCount times.
 If after repeatCount times the request still fails drop it and execute didFailHandler,
 passing the request to this handler. */
@property (nonatomic, assign) NSUInteger repeatCount;

/** If a request failed and repeatCount > 0, 
 the request will be repeated after timeout seconds. */
@property (nonatomic, assign) NSTimeInterval timeout;

/** This handler is called when all requests in queue have been succeeded or failed,
 i.e. there are no more requests to execute. */
@property (nonatomic, copy) dispatch_block_t didEmptyQueueHandler;

/** Called when a request is succeeded */
@property (nonatomic, copy) WebServiceQueueHandler didFinishHandler;

/** Called when a request failed repeatCount times */
@property (nonatomic, copy) WebServiceQueueHandler didFailHandler;

/** 
 @param theRepeatCount @see repeatCount
 @param theTimeout @see timeout */
- (id)initWithRepeatCount:(NSUInteger)theRepeatCount
             retryTimeout:(NSTimeInterval)theTimeout;

/** 
 Add theRequest to the queue. 
 If queue isn't suspended and there are no active requests running, 
 theRequest will be sent. */
- (void)addRequest:(id<DSWebServiceRequest>)theRequest;

/** Suspend queue and remove all requests */
- (void)reset;

- (NSInteger)countActiveRequests;

/** KVO-enabled */
- (BOOL)isSuspended;
- (void)setSuspended:(BOOL)theSuspendedFlag;

@end
