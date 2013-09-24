
typedef void (^proccedView_block_t)(UIView *theView);

@interface UIView (Subviews)
/** NOTE: Recursive function, so isn't designed for large view hierarchy */
- (void)enumerateSubviewsUsingBlock:(proccedView_block_t)theBlock;
@end
