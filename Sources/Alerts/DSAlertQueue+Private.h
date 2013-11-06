//
//  DSAlertQueue+Private.h
//  DSLib
//
//  Created by Alex on 23/10/2013.
//  Copyright (c) 2013 DS ltd. All rights reserved.
//
#import "DSAlertsQueue.h"

@class DSAlertsHandler;

@interface DSAlertsQueue (Private)
- (void)setAlertsHandler:(DSAlertsHandler *)handler;
@end
