//
//  NSTimer+DSAdditions.m
//  DSLib
//
//  Created by Diejmon on 9/4/14.
//  Copyright (c) 2014 DS ltd. All rights reserved.
//

#import "NSTimer+DSAdditions.h"
#import "NSDate+OAddittions.h"

@implementation NSTimer (DSAdditions)
- (void)fireAndReschedule
{
  [self setFireDate:[[NSDate now] dateByAddingTimeInterval:[self timeInterval]]];
  [self fire];
}
@end
