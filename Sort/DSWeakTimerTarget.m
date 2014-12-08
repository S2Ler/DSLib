//
//  DSWeakTimerTarget.m
//  DSLib
//
//  Created by Alexander Belyavskiy on 12/8/14.
//  Copyright (c) 2014 DS ltd. All rights reserved.
//

#import "DSWeakTimerTarget.h"

@interface DSWeakTimerTarget ()
@property (nonatomic, weak) id target;
@property (nonatomic, assign) SEL selector;
@end

@implementation DSWeakTimerTarget

- (instancetype)initWithTarget:(id)target selector:(SEL)sel
{
  self = [super init];
  if (self) {
    _target = target;
    _selector = sel;
  }
  return self;
}

- (void)timerDidFire:(NSTimer *)timer
{
  if(self.target)
  {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
    [self.target performSelector:self.selector withObject:timer];
#pragma clang diagnostic pop
  }
  else
  {
    [timer invalidate];
  }
}
@end