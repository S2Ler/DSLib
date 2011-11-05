
#import "PGAlertSkinView+Private.h"

@implementation PGAlertSkinView (Private)
+ (CGRect)frame:(CGRect)theOriginalFrame
  scaledWithRootViewFrameFrom:(CGRect)theRootViewOriginalFrame
  to:(CGRect)theRootViewNewFrame
{
  NSAssert(theRootViewOriginalFrame.size.width != 0, @"");
  NSAssert(theRootViewOriginalFrame.size.height != 0, @"");
  
  CGFloat widthScale = (theRootViewNewFrame.size.width 
                        / theRootViewOriginalFrame.size.width);
  CGFloat heightScale = (theRootViewNewFrame.size.height 
                         / theRootViewOriginalFrame.size.height);
  
  CGFloat newContentViewWidth = floor(theOriginalFrame.size.width * widthScale);
  CGFloat newContentViewHeight = floor(theOriginalFrame.size.height * heightScale);
  CGFloat newContentViewX = floor(theOriginalFrame.origin.x * widthScale);
  CGFloat newContentViewY = floor(theOriginalFrame.origin.y * heightScale);
  
  CGRect newContentViewFrame = CGRectMake(newContentViewX, newContentViewY,
                                          newContentViewWidth, newContentViewHeight);
  
  return newContentViewFrame;
}
@end
