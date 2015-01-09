
@import Foundation;
@import UIKit;

@interface UIFont(FromString)
/** \param aFontStringDefinintion font string format is @"[FontName] [FontSizeCGFloat]" */
+ (UIFont *)fontFromString:(NSString *)aFontStringDefinintion;
@end
