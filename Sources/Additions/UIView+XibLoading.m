#import "UIView+XibLoading.h"
#import "XibLoader.h"
#import <objc/runtime.h>

@implementation UIView (XibLoading)

+ (id)newViewFromXib
{
  id newInstance = [XibLoader firstViewInXibNamed:
                    NSStringFromClass([self class])];
    return newInstance;
}

@end
