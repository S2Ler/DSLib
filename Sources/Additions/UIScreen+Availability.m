#import "UIScreen+Availability.h"

@implementation UIScreen (Availability)
+ (CGFloat) mainScreenScale {
  static int respondsToScale = -1;
  if (respondsToScale == -1) {
    // Avoid calling this anymore than we need to.
    respondsToScale = !!([[UIScreen mainScreen] respondsToSelector:@selector(scale)]);
  }
  
  if (respondsToScale) {
    return [[UIScreen mainScreen] scale];
    
  } else {
    return 1;
  }
}
@end
