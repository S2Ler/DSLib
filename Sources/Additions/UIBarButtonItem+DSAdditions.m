
#import "UIBarButtonItem+DSAdditions.h"
#import "DSMacros.h"


@implementation UIBarButtonItem (DSAdditions)
+ (UIBarButtonItem *)barButtonWithImage:(UIImage *)image target:(id)target selector:(SEL)selector
{
  return [self barButtonWithImage:image title:nil target:target selector:selector];
}

+ (UIBarButtonItem *)barButtonWithImage:(UIImage *)image
                                  title:(NSString *)title
                                 target:(id)target
                               selector:(SEL)selector
{
  UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
  
  [button addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
  [button setTitle:title forState:UIControlStateNormal];
  [button setImage:image forState:UIControlStateNormal];
  
  if (title) {
    CGFloat spacing = 5; // the amount of spacing to appear between image and title
    button.imageEdgeInsets = UIEdgeInsetsMake(0, -spacing, 0, spacing);
    button.titleEdgeInsets = UIEdgeInsetsMake(0, spacing, 0, 0);
  }
  
  [button setTitleColor:DSRGB(140, 140, 140) forState:UIControlStateHighlighted];
  
  CGFloat buttonWidth = [image size].width;
  CGFloat buttonHeight = [image size].height;
  
  if (title) {
    const CGSize titleSize = [button.titleLabel.attributedText size];
    buttonWidth += titleSize.width;
    buttonWidth += (button.titleEdgeInsets.left + button.titleEdgeInsets.right);
//    buttonWidth += button.imageEdgeInsets.left + button.imageEdgeInsets.right;
    
    buttonHeight = MAX(titleSize.height, buttonHeight);
  }
  
  button.frame = CGRectMake(0, 0, buttonWidth, buttonHeight);
  
  UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
  return barButtonItem;
}

@end
