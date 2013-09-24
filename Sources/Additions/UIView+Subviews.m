
#import "UIView+Subviews.h"

@implementation UIView (Subviews)
- (void)enumerateSubviewsUsingBlock:(proccedView_block_t)theBlock
{
  for (UIView *subview in [self subviews]) {
    theBlock(subview);
    [subview enumerateSubviewsUsingBlock:theBlock];
  }
}
@end
