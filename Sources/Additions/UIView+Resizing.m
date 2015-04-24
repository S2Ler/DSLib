
#import "UIView+Resizing.h"

@implementation UIView (Resizing)

#pragma mark - Getting subviews
- (NSArray *)subviewsPassingTest:(BOOL(^)(UIView *subview))theTest {
    NSArray *allSubviews = [self subviews];
    
    NSArray *subviewsUnderLine = [allSubviews filteredArrayUsingPredicate:
                                  [NSPredicate predicateWithBlock:
                                   ^BOOL(id evaluatedObject, NSDictionary *bindings) {
                                       return theTest(evaluatedObject);
                                   }]
                                  ];

    return subviewsUnderLine;    
}

- (NSArray *)subviewsUnderLine:(CGFloat)theTopLine
{
    NSArray *subviewsUnderLine = [self subviewsPassingTest:^BOOL(UIView *subview) {
        CGRect subViewFrame = [subview frame];
        if (subViewFrame.origin.y >= theTopLine) {
            return YES;
        } else {
            return NO;
        }
    }];
    
    return subviewsUnderLine;
}

- (NSArray *)subviewsAboveLine:(CGFloat)theBottomLine
{
    NSArray *subviewsAboveLine = [self subviewsPassingTest:^BOOL(UIView *subview) {
        CGRect subViewFrame = [subview frame];        
        
        if (CGRectGetMaxY(subViewFrame) <= theBottomLine) {
            return YES;
        } else {
            return NO;
        }
    }];
    
    return subviewsAboveLine;
}

#pragma mark - Moving subviews
- (void)moveSubviews:(NSArray *)theSubViews
      upWithDistance:(CGFloat)theDistance
{
    [theSubViews enumerateObjectsUsingBlock:^(UIView *subView, NSUInteger idx, BOOL *stop) {
        [subView moveUp:theDistance];
    }];
}

- (void)moveSubviews:(NSArray *)theSubViews
    downWithDistance:(CGFloat)theDistance
{
    [theSubViews enumerateObjectsUsingBlock:^(UIView *subView, NSUInteger idx, BOOL *stop) {
        [subView moveDown:theDistance];
    }];
}

#pragma mark - Changing size
- (void)applyTransformationWithBlock:(void (^)(CGRect *theTransformation))theBlock
{
    CGRect frame = [self frame]; 
    {
        theBlock(&frame);
    }
    [self setFrame:frame];
}

- (void)moveUp:(CGFloat)theDistance
{
    [self applyTransformationWithBlock:^(CGRect *theTransformation) {
        theTransformation->origin.y -= theDistance;        
    }];
}

- (void)moveDown:(CGFloat)theDistance
{
    [self applyTransformationWithBlock:^(CGRect *theTransformation) {
        theTransformation->origin.y += theDistance;       
    }];
}

- (void)moveRight:(CGFloat)theDistance
{
    [self applyTransformationWithBlock:^(CGRect *theTransformation) {
        theTransformation->origin.x += theDistance;       
    }];
}

- (void)moveLeft:(CGFloat)theDistance
{
    [self applyTransformationWithBlock:^(CGRect *theTransformation) {
        theTransformation->origin.x -= theDistance;       
    }]; 
}


- (void)expandTop:(CGFloat)theDistance
{
    [self applyTransformationWithBlock:^(CGRect *theTransformation) {
        theTransformation->origin.y -= theDistance;    
        theTransformation->size.height += theDistance;  
    }];  
}

- (void)expandBottom:(CGFloat)theDistance
{
    [self applyTransformationWithBlock:^(CGRect *theTransformation) {
        theTransformation->size.height += theDistance;
    }];  
}

- (void)expandLeft:(CGFloat)theDistance
{
    [self applyTransformationWithBlock:^(CGRect *theTransformation) {
        theTransformation->size.width += theDistance;
        theTransformation->origin.x -= theDistance;
    }]; 
}

- (void)expandRight:(CGFloat)theDistance
{   
    [self applyTransformationWithBlock:^(CGRect *theTransformation) {
        theTransformation->size.width += theDistance;
    }];
}

- (void)shrinkTop:(CGFloat)theDistance
{
    [self applyTransformationWithBlock:^(CGRect *theTransformation) {
        theTransformation->origin.y += theDistance;
        theTransformation->size.height -= theDistance;
    }];     
}

- (void)shrinkBottom:(CGFloat)theDistance
{
    [self applyTransformationWithBlock:^(CGRect *theTransformation) {
        theTransformation->size.height -= theDistance;
    }];     
}

- (void)shrinkLeft:(CGFloat)theDistance
{    
    [self applyTransformationWithBlock:^(CGRect *theTransformation) {
        theTransformation->origin.x += theDistance;
        theTransformation->size.width -= theDistance;
    }]; 
}

- (void)shrinkRight:(CGFloat)theDistance
{
    [self applyTransformationWithBlock:^(CGRect *theTransformation) {
        theTransformation->size.width -= theDistance;
    }]; 
}

- (void)layoutToFit
{
  CGRect newFrame = self.frame;
  newFrame.size = [self systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
  self.frame = newFrame;
}
@end
