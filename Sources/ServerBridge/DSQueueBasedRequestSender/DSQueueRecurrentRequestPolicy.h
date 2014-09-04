//
//  DSQueueRecurrentRequestPolicy.h
//  DSLib
//
//  Created by Diejmon on 9/3/14.
//  Copyright (c) 2014 DS ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DSQueueRecurrentRequestPolicy : NSObject
@property (nonatomic, assign) NSTimeInterval repeatTimeInterval;
@property (nonatomic, assign) BOOL runOnAdd;
@end
