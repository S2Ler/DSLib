
@interface UIImage (DSAdditions)

- (BOOL)hasAlpha;
- (UIImage *)imageWithAlpha;
- (UIImage *)transparentBorderImage:(NSUInteger)borderSize;

- (UIImage *)maskedImageWithColor:(UIColor *)color;
- (UIImage *)maskedImageWithColor:(UIColor *)color blendMode:(CGBlendMode)mode;

- (BOOL)saveToPath:(NSString *)path
             error:(__autoreleasing NSError **)error
         converter:(NSData *(^)(UIImage *image, NSString **getExtension))converter
           getSize:(DSFileSize *)size;

@end
