
#import <UIKit/UIKit.h>

@interface UIView (Resizing)
//Getting subviews
//--inclusive views with origin.Y == theTopLine
- (NSArray *)subviewsUnderLine:(CGFloat)theTopLine;
//--inclusive views with MaxX == theBottomLine
- (NSArray *)subviewsAboveLine:(CGFloat)theBottomLine;

//Moving subviews
- (void)moveSubviews:(NSArray *)theSubViews
      upWithDistance:(CGFloat)theDistance;
- (void)moveSubviews:(NSArray *)theSubViews
    downWithDistance:(CGFloat)theDistance;

//Handy methods for changing size of the view
- (void)moveUp:(CGFloat)theDistance;
- (void)moveDown:(CGFloat)theDistance;
- (void)moveRight:(CGFloat)theDistance;
- (void)moveLeft:(CGFloat)theDistance;

- (void)expandTop:(CGFloat)theDistance;
- (void)expandBottom:(CGFloat)theDistance;
- (void)expandLeft:(CGFloat)theDistance;
- (void)expandRight:(CGFloat)theDistance;
- (void)shrinkTop:(CGFloat)theDistance;
- (void)shrinkBottom:(CGFloat)theDistance;
- (void)shrinkLeft:(CGFloat)theDistance;
- (void)shrinkRight:(CGFloat)theDistance;

- (void)applyTransformationWithBlock:(void (^)(CGRect *theTransformation))theBlock;

- (void)layoutToFit;
@end
