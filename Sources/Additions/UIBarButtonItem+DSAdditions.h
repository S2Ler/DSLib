
#import <Foundation/Foundation.h>

@interface UIBarButtonItem (DSAdditions)
+ (UIBarButtonItem *)barButtonWithImage:(UIImage *)image
                                 target:(id)target
                               selector:(SEL)selector;
@end
