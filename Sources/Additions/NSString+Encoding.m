
#import "NSString+Encoding.h"
#import <CommonCrypto/CommonDigest.h>

@implementation NSString (NSString)
- (BOOL)isANSI {
  NSUInteger charCount = [self length];
  
  for (NSUInteger i = 0; i < charCount; i++) {
    unichar c = [self characterAtIndex:i];
    
    if (c > 127) return NO;
  }
  
  return YES;
}

- (NSString *)MD5Hash {
  const char *str = [self UTF8String];
  unsigned char r[CC_MD5_DIGEST_LENGTH];
  CC_MD5(str, strlen(str), r);
  NSString *MD5Hash = 
  [NSString stringWithFormat:@"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
   r[0], r[1], r[2], r[3], r[4], r[5], r[6], r[7], r[8], r[9], r[10], r[11], r[12], r[13], r[14], r[15]];
  return MD5Hash;
}

+ (NSNumberFormatter *)sizeFormatter {
  static NSNumberFormatter *formatter = nil;
  
  if (!formatter) {
    formatter = [[NSNumberFormatter alloc] init];
    [formatter setFormatterBehavior:NSNumberFormatterBehaviorDefault];     
    [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
    [formatter setPositiveFormat:@"#.#"];
    
  }
  
  return formatter;
}

+ (NSString *)sizePrettyStringWithBytes:(unsigned long long)theSizeInBytes 
{
  NSString* sizeUnit = @"bytes";
  
  long double size = theSizeInBytes;
  
  if (size > 1024)
  {
    size /= 1024.;
    sizeUnit = @"KB";
  }
  if (size > 1024)
  {
    size /= 1024.;
    sizeUnit = @"MB";
  }
  if (size > 1024)
  {
    size /= 1024.;
    sizeUnit = @"GB";
  }
  if (size > 1024) {
    size /= 1024.;
    sizeUnit = @"TB";
  }
  if (size > 1024) {
    size /= 1024.;
    sizeUnit = @"PB";
  }
  
  NSString *prettyString 
  = [NSString stringWithFormat:@"%@ %@", 
     [[self sizeFormatter] stringFromNumber:
      [NSNumber numberWithFloat:size]], 
     sizeUnit];
  
  return prettyString;
}

- (NSString *)localized {
  return NSLocalizedString(self, nil);
}

- (UIImage *)image {
  return [UIImage imageNamed:self];
}
@end
