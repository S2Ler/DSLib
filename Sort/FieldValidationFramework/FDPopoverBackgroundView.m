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
  return UIEdgeInsetsMake(3, 3, 3, 3);
}

+ (CGFloat)arrowBase {
  return 24.0;
}

+ (CGFloat)arrowHeight {
  return 14;
}

+ (BOOL)wantsDefaultContentAppearance {
  return true;
}

- (void)setArrowDirection:(UIPopoverArrowDirection)arrowDirection {
  _arrowDirection = UIPopoverArrowDirectionDown;
  [self setNeedsLayout];
}

- (UIPopoverArrowDirection)arrowDirection
{
  return UIPopoverArrowDirectionDown;
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

- (void)drawRect:(CGRect)errorPopupFrame
{
  const CGFloat arrowMiddle = errorPopupFrame.size.width / 2.0 + _arrowOffset;

  CGContextRef context = UIGraphicsGetCurrentContext();
  
  CGContextClearRect(context, errorPopupFrame);
  
  //// Color Declarations
  UIColor* background = DSRGB(255, 236, 236);
  UIColor* stroke = DSRGB(243, 91, 94);
  
  const CGFloat arrowHeight = [self.class arrowHeight]+2;
  
  //// Bezier Drawing
  UIBezierPath* bezierPath = UIBezierPath.bezierPath;
  [bezierPath moveToPoint: CGPointMake(CGRectGetMaxX(errorPopupFrame) - 2, CGRectGetMinY(errorPopupFrame) + 13)];
  [bezierPath addLineToPoint: CGPointMake(CGRectGetMaxX(errorPopupFrame) - 2, CGRectGetMaxY(errorPopupFrame) - 11-arrowHeight)];
  [bezierPath addCurveToPoint: CGPointMake(CGRectGetMaxX(errorPopupFrame) - 13, CGRectGetMaxY(errorPopupFrame) - arrowHeight) controlPoint1: CGPointMake(CGRectGetMaxX(errorPopupFrame) - 2, CGRectGetMaxY(errorPopupFrame) - 4.92-arrowHeight) controlPoint2: CGPointMake(CGRectGetMaxX(errorPopupFrame) - 6.92, CGRectGetMaxY(errorPopupFrame) - arrowHeight)];
  [bezierPath addLineToPoint: CGPointMake(CGRectGetMinX(errorPopupFrame) + arrowMiddle+self.class.arrowBase/2.0, CGRectGetMaxY(errorPopupFrame) - arrowHeight)];
  [bezierPath addLineToPoint: CGPointMake(CGRectGetMinX(errorPopupFrame) + arrowMiddle, CGRectGetMaxY(errorPopupFrame) - arrowHeight + self.class.arrowHeight)];
  [bezierPath addLineToPoint: CGPointMake(CGRectGetMinX(errorPopupFrame) + arrowMiddle-self.class.arrowBase/2.0, CGRectGetMaxY(errorPopupFrame) - arrowHeight)];
  [bezierPath addLineToPoint: CGPointMake(CGRectGetMinX(errorPopupFrame) + 13, CGRectGetMaxY(errorPopupFrame) - arrowHeight)];
  [bezierPath addCurveToPoint: CGPointMake(CGRectGetMinX(errorPopupFrame) + 2, CGRectGetMaxY(errorPopupFrame) - 11-arrowHeight) controlPoint1: CGPointMake(CGRectGetMinX(errorPopupFrame) + 6.92, CGRectGetMaxY(errorPopupFrame) - arrowHeight) controlPoint2: CGPointMake(CGRectGetMinX(errorPopupFrame) + 2, CGRectGetMaxY(errorPopupFrame) - 4.92-arrowHeight)];
  [bezierPath addLineToPoint: CGPointMake(CGRectGetMinX(errorPopupFrame) + 2, CGRectGetMinY(errorPopupFrame) + 13)];
  [bezierPath addCurveToPoint: CGPointMake(CGRectGetMinX(errorPopupFrame) + 13, CGRectGetMinY(errorPopupFrame) + 2) controlPoint1: CGPointMake(CGRectGetMinX(errorPopupFrame) + 2, CGRectGetMinY(errorPopupFrame) + 6.92) controlPoint2: CGPointMake(CGRectGetMinX(errorPopupFrame) + 6.92, CGRectGetMinY(errorPopupFrame) + 2)];
  [bezierPath addLineToPoint: CGPointMake(CGRectGetMaxX(errorPopupFrame) - 13, CGRectGetMinY(errorPopupFrame) + 2)];
  [bezierPath addCurveToPoint: CGPointMake(CGRectGetMaxX(errorPopupFrame) - 2, CGRectGetMinY(errorPopupFrame) + 13) controlPoint1: CGPointMake(CGRectGetMaxX(errorPopupFrame) - 6.92, CGRectGetMinY(errorPopupFrame) + 2) controlPoint2: CGPointMake(CGRectGetMaxX(errorPopupFrame) - 2, CGRectGetMinY(errorPopupFrame) + 6.92)];
  [bezierPath closePath];
  [background setFill];
  [bezierPath fill];
  [stroke setStroke];
  bezierPath.lineWidth = 2;
  [bezierPath stroke];
}
@end
