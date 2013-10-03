//
//  DSWebServiceQueue.m
//
//  Created by Alexander Belyavskiy on 4/26/12.
//

#pragma mark - include
#import "DSWebServiceQueue.h"
#import "DSWebServiceRequest.h"

#pragma mark - private
@interface DSWebServiceQueue()

@end

@implementation DSWebServiceQueue
- (void)addRequest:(id <DSWebServiceRequest>)theRequest
    finishedAction:(SEL)theFinishedAction
{
  assert([theRequest isKindOfClass:[NSOperation class]] == YES);

  NSOperation *requestOperation = (NSOperation *) theRequest;
  [self addOperation:requestOperation finishedAction:theFinishedAction];
}

@end
