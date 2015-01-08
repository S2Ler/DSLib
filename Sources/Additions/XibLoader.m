#import "XibLoader.h"
@import UIKit;

@implementation XibLoader
+ (NSArray *)xibNamed:(NSString *)theXibName
{
  return [self xibNamed:theXibName inBundle:nil];
}

+ (NSArray *)xibNamed:(NSString *)theXibName inBundle:(NSBundle *)bundle
{
  if (bundle == nil) {
    bundle = [NSBundle mainBundle];
  }
  
  NSArray *xibElements = [bundle loadNibNamed:theXibName owner:nil options:nil];
  if ([xibElements count] > 0) {
    return xibElements;
  } else {
    return nil;
  }
}

+ (id)firstViewInXibNamed:(NSString *)theXibName {
  return [self firstViewInXibNamed:theXibName inBundle:nil];
}

+ (id)firstViewInXibNamed:(NSString *)theXibName inBundle:(NSBundle *)bundle
{
  NSArray *xibElements = [self xibNamed:theXibName inBundle:bundle];
  
  if ([xibElements count] > 0) {
    return [xibElements objectAtIndex:0];
  } else {
    return nil;
  }
}
@end
