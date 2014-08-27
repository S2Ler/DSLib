//
//  DSGradientView.m
//  DSLib
//
//  Created by Diejmon on 8/27/14.
//  Copyright (c) 2014 DS ltd. All rights reserved.
//

#pragma mark - include
#import "DSGradientView.h"

@interface DSGradientView ()
@property (nonatomic, weak) CAGradientLayer *gradientLayer;
@end

@implementation DSGradientView
@dynamic colors;
@dynamic locations;
@dynamic startPoint, endPoint;

- (CAGradientLayer *)gradientLayer
{
  if (!_gradientLayer) {
    _gradientLayer = [CAGradientLayer layer];
    [self.layer insertSublayer:_gradientLayer atIndex:0];
  }
  
  return _gradientLayer;
}

- (void)willMoveToWindow:(UIWindow *)newWindow
{
  [super willMoveToWindow:newWindow];
  
  //Trigger creation
  [self gradientLayer];
}

- (void)forwardInvocation:(NSInvocation *)anInvocation
{
  [anInvocation invokeWithTarget:[self gradientLayer]];
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector
{
  return [[self gradientLayer] methodSignatureForSelector:aSelector];
}

- (void)layoutSubviews
{
  [super layoutSubviews];
  [[self gradientLayer] setFrame:[self bounds]];
}

@end
