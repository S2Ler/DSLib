
@import UIKit;
#import "DSConstants.h"

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

#pragma mark - resize
- (UIImage *)croppedImage:(CGRect)bounds;
- (UIImage *)thumbnailImage:(NSInteger)thumbnailSize
          transparentBorder:(NSUInteger)borderSize
               cornerRadius:(NSUInteger)cornerRadius
       interpolationQuality:(CGInterpolationQuality)quality;
- (UIImage *)resizedImage:(CGSize)newSize
     interpolationQuality:(CGInterpolationQuality)quality;
- (UIImage *)resizedImageWithContentMode:(UIViewContentMode)contentMode
                                  bounds:(CGSize)bounds
                    interpolationQuality:(CGInterpolationQuality)quality;

- (UIImage *)roundedCornerImage:(NSInteger)cornerSize borderSize:(NSInteger)borderSize;
@end
