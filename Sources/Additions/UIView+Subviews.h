
@import UIKit;

typedef void (^proccedView_block_t)(UIView *theView);

@interface UIView (Subviews)
/** NOTE: Recursive function, so isn't designed for large view hierarchy */
- (void)enumerateSubviewsUsingBlock:(proccedView_block_t)theBlock;

- (UIImage *)getSnapshot NS_AVAILABLE_IOS(7_0);

- (UIView *)findFirstResponder;
@end
