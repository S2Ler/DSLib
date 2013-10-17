
#import "DSReplaceRootViewControllerSegue.h"


@implementation DSReplaceRootViewControllerSegue
- (void)perform
{
    [UIView transitionFromView:[[self sourceViewController] view]
                        toView:[[self destinationViewController] view]
                      duration:0.25
                       options:UIViewAnimationOptionTransitionCrossDissolve
                    completion:nil];
  
  UIWindow *keyWindow = [[UIApplication sharedApplication] keyWindow];
  [keyWindow setRootViewController:[self destinationViewController]];
}
@end
