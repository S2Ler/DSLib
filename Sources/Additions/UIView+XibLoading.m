#import "UIView+XibLoading.h"
#import "XibLoader.h"
#import <objc/runtime.h>

@implementation UIView (XibLoading)

+ (id)newViewFromXib
{
  id newInstance = [XibLoader firstViewInXibNamed:NSStringFromClass([self class])];
  return newInstance;
}

+ (id)newViewFromXibAtIndex:(NSUInteger)index
{
  NSArray *xib = [XibLoader xibNamed:NSStringFromClass([self class])];
  if ([xib count] > index) {
    return [xib objectAtIndex:index];
  }

  return nil;
}

@end
