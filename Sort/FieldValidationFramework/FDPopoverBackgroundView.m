//
//  FDPopoverBackgroundView.m
//  DSLib
//
//  Created by Alexander Belyavskiy on 4/8/15.
//  Copyright (c) 2015 DS ltd. All rights reserved.
//

#import "FDPopoverBackgroundView.h"
#import "DSMacros.h"

@interface FDPopoverBackgroundView ()
{
  UIPopoverArrowDirection _arrowDirection;
  CGFloat _arrowOffset;
}
@end

@implementation FDPopoverBackgroundView

+ (UIEdgeInsets)contentViewInsets {
  return UIEdgeInsetsMake(2, 2, 2, 9);
}

+ (CGFloat)arrowBase {
  return 14.0;
}

+ (CGFloat)arrowHeight {
  return 7;
}

+ (BOOL)wantsDefaultContentAppearance {
  return true;
}

- (void)setArrowDirection:(UIPopoverArrowDirection)arrowDirection {
  _arrowDirection = UIPopoverArrowDirectionRight;
  [self setNeedsLayout];
}

- (UIPopoverArrowDirection)arrowDirection
{
  return UIPopoverArrowDirectionRight;
}

- (void)setArrowOffset:(CGFloat)arrowOffset {
  _arrowOffset = arrowOffset;
  [self setNeedsLayout];
}

- (CGFloat)arrowOffset {
  return _arrowOffset;
}

- (instancetype)initWithFrame:(CGRect)frame
{
  self = [super initWithFrame:frame];
  if (self) {
    self.layer.shadowColor = [UIColor clearColor].CGColor;
    self.backgroundColor = [UIColor clearColor];
    self.layer.masksToBounds = false;
  }
  return self;
}

- (void)drawRect:(CGRect)frame
{
  
  const CGFloat arrowMiddle = frame.size.height / 2.0 + _arrowOffset;

  CGContextRef context = UIGraphicsGetCurrentContext();
  
  CGContextClearRect(context, frame);
  
  //// Rectangle Drawing
  //// Rectangle Drawing
  UIBezierPath* rectanglePath = UIBezierPath.bezierPath;
  [rectanglePath moveToPoint: CGPointMake(CGRectGetMinX(frame) + 1, CGRectGetMaxY(frame) - 8.31)];
  [rectanglePath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 7.51, CGRectGetMaxY(frame) - 1) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 1, CGRectGetMaxY(frame) - 4.27) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 3.92, CGRectGetMaxY(frame) - 1)];
  [rectanglePath addLineToPoint: CGPointMake(CGRectGetMaxX(frame) - 15.52, CGRectGetMaxY(frame) - 1)];
  [rectanglePath addCurveToPoint: CGPointMake(CGRectGetMaxX(frame) - 9.24, CGRectGetMaxY(frame) - 8.15) controlPoint1: CGPointMake(CGRectGetMaxX(frame) - 11.93, CGRectGetMaxY(frame) - 1) controlPoint2: CGPointMake(CGRectGetMaxX(frame) - 9.24, CGRectGetMaxY(frame) - 4.12)];
  [rectanglePath addLineToPoint: CGPointMake(CGRectGetMaxX(frame) - 9.24, CGRectGetMinY(frame) + arrowMiddle + self.class.arrowBase/2.0)];
  [rectanglePath addLineToPoint: CGPointMake(CGRectGetMaxX(frame) - (9.24-self.class.arrowHeight), CGRectGetMinY(frame) + arrowMiddle)];
  [rectanglePath addLineToPoint: CGPointMake(CGRectGetMaxX(frame) - 9.24, CGRectGetMinY(frame) + arrowMiddle - self.class.arrowBase/2.0)];
  [rectanglePath addLineToPoint: CGPointMake(CGRectGetMaxX(frame) - 9.24, CGRectGetMinY(frame) + 8.63)];
  [rectanglePath addCurveToPoint: CGPointMake(CGRectGetMaxX(frame) - 15.52, CGRectGetMinY(frame) + 1) controlPoint1: CGPointMake(CGRectGetMaxX(frame) - 9.24, CGRectGetMinY(frame) + 4.6) controlPoint2: CGPointMake(CGRectGetMaxX(frame) - 11.93, CGRectGetMinY(frame) + 1)];
  [rectanglePath addLineToPoint: CGPointMake(CGRectGetMinX(frame) + 7.51, CGRectGetMinY(frame) + 1)];
  [rectanglePath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 1, CGRectGetMinY(frame) + 8.31) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 3.92, CGRectGetMinY(frame) + 1) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 1, CGRectGetMinY(frame) + 4.27)];
  [rectanglePath addLineToPoint: CGPointMake(CGRectGetMinX(frame) + 1, CGRectGetMaxY(frame) - 8.31)];
  [rectanglePath closePath];
  rectanglePath.lineJoinStyle = kCGLineJoinRound;
  
  rectanglePath.lineWidth = 2;
  
  [DSRGB(243, 91, 94) setStroke];
  [DSRGB(255, 236, 236) setFill];
  [rectanglePath fill];
  [rectanglePath stroke];
}
@end
