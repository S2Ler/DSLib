#import "UIView+XibLoading.h"
#import "XibLoader.h"

@implementation UIView (XibLoading)
+ (id)newViewFromXib
{
  id newInstance = [XibLoader firstViewInXibNamed:
                    NSStringFromClass([self class])];
  return [newInstance retain];
}

@end
