//
//  DSWeakTimerTarget.h
//  DSLib
//
//  Created by Alexander Belyavskiy on 12/8/14.
//  Copyright (c) 2014 DS ltd. All rights reserved.
//

@import Foundation;

@interface DSWeakTimerTarget : NSObject
- (instancetype)initWithTarget:(id)target selector:(SEL)sel;
- (void)timerDidFire:(NSTimer *)timer;;
@end
