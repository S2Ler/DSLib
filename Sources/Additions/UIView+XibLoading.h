
#import <UIKit/UIKit.h>

@interface UIView (XibLoading)
/** Class name and xib name should be the same. */
+ (instancetype)newViewFromXib;
+ (instancetype)newViewFromXibInBundle:(NSBundle *)bundle;
+ (id)newViewFromXibAtIndex:(NSUInteger)index;
+ (id)newViewFromXibAtIndex:(NSUInteger)index inBundle:(NSBundle *)bundle;
@end
