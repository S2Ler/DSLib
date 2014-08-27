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
@end

@implementation DSGradientView

- (void)sharedInit
{
  [self setStartPoint:CGPointMake(0.5, 0)];
  [self setEndPoint:CGPointMake(0.5, 1)];
}

- (id)init
{
  self = [super init];
  if (self) {
    [self sharedInit];
  }
  
  return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
  self = [super initWithCoder:aDecoder];
  if (self) {
    [self sharedInit];
  }
  return self;
}

- (id)initWithFrame:(CGRect)frame
{
  self = [super initWithFrame:frame];
  if (self) {
    [self sharedInit];
  }
  return self;
}

- (void)drawRect:(CGRect)rect
{
  CGContextRef context = UIGraphicsGetCurrentContext();
  CGGradientRef gradient;
  CGColorSpaceRef colorspace;
  CGFloat *locations = calloc([[self locations] count] ? [[self locations] count] : 2, sizeof(CGFloat));
  if ([[self locations] count]) {
    [[self locations] enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
      locations[idx] = [obj floatValue];
    }];
  }
  else {
    locations[0] = 0;
    locations[1] = 1;
  }
  
  colorspace = CGColorSpaceCreateDeviceRGB();
  
  gradient = CGGradientCreateWithColors(colorspace,
                                        (CFArrayRef)[self colors], NULL);
  CGPoint startPoint, endPoint;
  startPoint.x = rect.size.width * [self startPoint].x;
  startPoint.y = rect.size.height * [self startPoint].y;
  
  endPoint.x = rect.size.width * [self endPoint].x;
  endPoint.y = rect.size.height * [self endPoint].y;
  
  CGContextDrawLinearGradient(context, gradient,
                              startPoint, endPoint, 0);
}

@end
