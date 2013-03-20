
#import "UIBarButtonItem+DSAdditions.h"


@implementation UIBarButtonItem (DSAdditions)
+ (UIBarButtonItem *)barButtonWithImage:(UIImage *)image target:(id)target selector:(SEL)selector
{
  UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
  [button addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
  [button setImage:image forState:UIControlStateNormal];
  [button setFrame:CGRectMake(0, 0, [image size].width, [image size].height)];
  UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
  return barButtonItem;
}

@end
