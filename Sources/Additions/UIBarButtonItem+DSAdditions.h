
@import Foundation;
@import UIKit;

@interface UIBarButtonItem (DSAdditions)
+ (UIBarButtonItem *)barButtonWithImage:(UIImage *)image
                                 target:(id)target
                               selector:(SEL)selector;
+ (UIBarButtonItem *)barButtonWithImage:(UIImage *)image
                                  title:(NSString *)title
                                 target:(id)target
                               selector:(SEL)selector;

@end
