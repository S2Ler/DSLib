
#import <UIKit/UIKit.h>

@interface UIView (ViewsEnumeration)
- (void)enumerateViewsUsingBlock:(void(^)(UIView *view))block;
- (UIView *)firstSuperviewOfClass:(Class)class;
@end
