
#import <Foundation/Foundation.h>

#define isPhone568 ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone && [UIScreen mainScreen].bounds.size.height == 568)
/** Don't append extension */
#define iPhone568ImagePNGNamed(image) (isPhone568 ? [NSString stringWithFormat:@"%@-568h", image] : image)
#define iPhone568ImageNamed(image) (isPhone568 ? [NSString stringWithFormat:@"%@-568h.%@", [image stringByDeletingPathExtension], [image pathExtension]] : image)
#define iPhone568ImagePNG(image) ([UIImage imageNamed:iPhone568ImagePNGNamed(image)])
#define iPhone568Image(image) ([UIImage imageNamed:iPhone568ImageNamed(image)])




@interface NSString (Encoding)

/** Determine whether target string contains only ANSI chars. */
- (BOOL)isANSI;

/** Make a MD5 hash from the target string 
 \return MD5 hash of the target string */
- (NSString *)MD5Hash;

/** Creates a string from the bytes in form:
 100 bytes 10 KB, 20 MB, 30 GB, 40 TB, 50 PB */
+ (NSString *)sizePrettyStringWithBytes:(DSFileSize)theSizeInBytes;
+ (NSString *)sizePrettyString1000NominationWithBytes:(DSFileSize)theSizeInBytes;

/** Apply NSLocalizedString to the target string */
- (NSString *)localized;

/** Return image from the app Bundle with name of the target string taking into account 4' screen size.
* Files naming convention:
* Non-Retina: image.[ext]
* Retina: image@2x.[ext]
* 4' Retina: image-568h@2x.[ext]
* */
- (UIImage *)image;

- (NSDictionary *)loadPlistFromBundle;

- (NSString *)trimWhiteSpaces;

- (NSString *)urlCompliantString;

+ (NSString *)generateUUIDString;



@end
