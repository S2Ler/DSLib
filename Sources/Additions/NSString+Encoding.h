#import <Foundation/Foundation.h>

@interface NSString (Encoding)

/** Determine whether target string contains only ANSI chars. */
- (BOOL)isANSI;

/** Make a MD5 hash from the target string 
 \return MD5 hash of the target string */
- (NSString *)MD5Hash;

/** Creates a string from the bytes in form:
 100 bytes 10 KB, 20 MB, 30 GB, 40 TB, 50 PB */
+ (NSString *)sizePrettyStringWithBytes:(unsigned long long)theSizeInBytes;

/** Apply NSLocalizedString to the target string */
- (NSString *)localized;

/** Return image from the app Bundle with name of the target string */
- (UIImage *)image;
@end
