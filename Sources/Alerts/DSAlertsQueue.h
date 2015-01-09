//
//  DSAlertsQueue.h
//  DSLib
//
//  Created by Alex on 23/10/2013.
//  Copyright (c) 2013 DS ltd. All rights reserved.
//

@import Foundation;

@class DSAlertsHandler;
@class DSMessage;
@class DSAlert;

@interface DSAlertsQueue : NSObject {
  @private
  __weak DSAlertsHandler *_alertsHandler;
}

/** Interval between which queue will commit all objects added. Default is 2s */
@property (nonatomic, assign) NSTimeInterval despatchInterval;

- (void)addMessage:(DSMessage *)message;
- (void)addAlert:(DSAlert *)alert modal:(BOOL)isModal;
- (void)addError:(NSError *)error;
- (void)addParseError:(NSError *)error;

- (void)commit;
                 
@end
