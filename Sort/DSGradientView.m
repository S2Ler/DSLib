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

- (void)layoutSubviews
{
  [super layoutSubviews];
  [[self gradientLayer] setFrame:[self bounds]];
}

- (void)setColors:(NSArray *)colors
{
  [[self gradientLayer] setColors:colors];
}

- (NSArray *)colors
{
  return [[self gradientLayer] colors];
}

- (NSArray *)locations
{
  return [[self gradientLayer]locations];
}

- (CGPoint)startPoint
{
  return [[self gradientLayer] startPoint];
}

- (CGPoint)endPoint
{
  return [[self gradientLayer] endPoint];
}

- (void)setLocations:(NSArray *)locations
{
  [[self gradientLayer] setLocations:locations];
}

- (void)setStartPoint:(CGPoint)startPoint
{
  [[self gradientLayer] setStartPoint:startPoint];
}

- (void)setEndPoint:(CGPoint)endPoint
{
  [[self gradientLayer] setEndPoint:endPoint];
}
@end
