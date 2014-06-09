
@interface UIImage (DSAdditions)

- (BOOL)hasAlpha;
- (UIImage *)imageWithAlpha;
- (UIImage *)transparentBorderImage:(NSUInteger)borderSize;

- (UIImage *)maskedImageWithColor:(UIColor *)color;
- (UIImage *)maskedImageWithColor:(UIColor *)color blendMode:(CGBlendMode)mode;

@end
