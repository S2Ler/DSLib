
#import "UIApplication+DSAdditions.h"


@implementation UIApplication (DSAdditions)
- (void)changeApplicationIconBadgeNumberBy:(NSInteger)delta
{
  [self setApplicationIconBadgeNumber:MAX(0, [[UIApplication sharedApplication] applicationIconBadgeNumber] + delta)];
}
@end
