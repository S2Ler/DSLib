
#import <UIKit/UIKit.h>

@interface UIView (XibLoading)
/** Class name and xib name should be the same. */
+ (instancetype)newViewFromXib;
+ (id)newViewFromXibAtIndex:(NSUInteger)index;
@end
