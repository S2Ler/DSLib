
#import "PGAlertSkinView.h"

@interface PGAlertSkinView (Private)
+ (CGRect)frame:(CGRect)theOriginalFrame
  scaledWithRootViewFrameFrom:(CGRect)theRootViewOriginalFrame
  to:(CGRect)theRootViewNewFrame;
@end
