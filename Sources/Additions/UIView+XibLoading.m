#import "UIView+XibLoading.h"
#import "XibLoader.h"
#import <objc/runtime.h>

@implementation UIView (XibLoading)

+ (id)newViewFromXib
{
  return [self newViewFromXibInBundle:[NSBundle bundleForClass:self]];
}

+ (instancetype)newViewFromXibInBundle:(NSBundle *)bundle
{
  id newInstance = [XibLoader firstViewInXibNamed:NSStringFromClass([self class]) inBundle:bundle];
  return newInstance;
}

+ (id)newViewFromXibAtIndex:(NSUInteger)index
{
  return [self newViewFromXibAtIndex:index inBundle:[NSBundle bundleForClass:self]];
}

+ (id)newViewFromXibAtIndex:(NSUInteger)index inBundle:(NSBundle *)bundle
{
  NSArray *xib = [XibLoader xibNamed:NSStringFromClass([self class]) inBundle:bundle];
  if ([xib count] > index) {
    return [xib objectAtIndex:index];
  }
  
  return nil;
}
@end
