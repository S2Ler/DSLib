//
//  DSWebServiceQueue.h
//
//  Created by Alexander Belyavskiy on 4/26/12.
//

#import <Foundation/Foundation.h>
#import "QWatchedOperationQueue.h"

@protocol DSWebServiceRequest;


@interface DSWebServiceQueue : QWatchedOperationQueue
/** \param theRequest should be inherited from NSOperation !!!
 *  Convenient name for addOperation:finishedAction: method */
- (void)addRequest:(id<DSWebServiceRequest>)theRequest
    finishedAction:(SEL)theFinishedAction;
@end
