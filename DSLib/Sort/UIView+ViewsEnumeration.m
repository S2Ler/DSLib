
#import "UIView+ViewsEnumeration.h"

@implementation UIView (ViewsEnumeration)
- (void)enumerateViewsUsingBlock:(void(^)(UIView *view))block
{
    for (UIView *subView in [self subviews]) {
        block(subView);
        [subView enumerateViewsUsingBlock:block];
    }
}

- (UIView *)firstSuperviewOfClass:(Class)class
{
  if ([[self superview] isKindOfClass:class]) {
    return [self superview];
  }
  else {
    return [[self superview] firstSuperviewOfClass:class];
  }
}
@end
