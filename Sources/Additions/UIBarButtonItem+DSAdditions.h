
@import Foundation;
@import UIKit;

@interface UIBarButtonItem (DSAdditions)
+ (UIBarButtonItem *)barButtonWithImage:(UIImage *)image
                                 target:(id)target
                               selector:(SEL)selector;
@end
