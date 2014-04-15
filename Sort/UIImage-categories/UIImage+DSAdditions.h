
@interface UIImage (DSAdditions)

- (BOOL)hasAlpha;
- (UIImage *)imageWithAlpha;
- (UIImage *)transparentBorderImage:(NSUInteger)borderSize;

- (UIImage *)maskedImageWithColor:(UIColor *)color;

@end
