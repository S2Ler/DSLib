
#import "NSString+Encoding.h"
#import "NSString+Extras.h"
#import <CommonCrypto/CommonDigest.h>

@implementation NSString (Encoding)
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
  CC_MD5(str, (CC_LONG)strlen(str), r);
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

+ (NSString *)sizePrettyStringWithBytes:(DSFileSize)theSizeInBytes
{
  return [self sizePrettyStringWithBytes:theSizeInBytes divider:1024];
}

+ (NSString *)sizePrettyString1000NominationWithBytes:(DSFileSize)theSizeInBytes
{
  return [self sizePrettyStringWithBytes:theSizeInBytes divider:1000];
}

+ (NSString *)sizePrettyStringWithBytes:(DSFileSize)theSizeInBytes divider:(float)divider
{
  NSString* sizeUnit = @"bytes";
  
  long double size = theSizeInBytes;
  
  if (size >= divider)
  {
    size /= divider;
    sizeUnit = @"KB";
  }
  if (size >= divider)
  {
    size /= divider;
    sizeUnit = @"MB";
  }
  if (size >= divider)
  {
    size /= divider;
    sizeUnit = @"GB";
  }
  if (size >= divider) {
    size /= divider;
    sizeUnit = @"TB";
  }
  if (size >= divider) {
    size /= divider;
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
  UIImage *image = nil;
  if (![[self pathExtension] isEmpty]) {
    image = iPhone568Image(self);
  }
  else {
    image = iPhone568ImagePNG(self);
  }
  
  if (!image) {
    image = [UIImage imageNamed:self];
  }
  
  return image;
}

- (NSDictionary *)loadPlistFromBundle
{
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:self ofType:@"plist"];
    if (plistPath) {
        NSDictionary *plist = [[NSDictionary alloc] initWithContentsOfFile:plistPath];
        return plist;
    } else {
        return nil;
    }
}

- (NSString *)trimWhiteSpaces
{
  return [self stringByTrimmingCharactersInSet:
          [NSCharacterSet whitespaceCharacterSet]];
}

- (NSString *)urlCompliantString;
{	
  NSString *s 
  = (__bridge_transfer id)CFURLCreateStringByAddingPercentEscapes
  (
   NULL, 
   (__bridge CFStringRef)[self mutableCopy],
   NULL,
   CFSTR("￼=,!$&'()*+;@?\n\"<>#\t :/"),
   kCFStringEncodingUTF8
   ); 
  
  return s;
}

+ (NSString *)generateUUIDString
{
  CFUUIDRef uuid = CFUUIDCreate(kCFAllocatorDefault);

  NSString *uuidString
    = (__bridge_transfer NSString *)CFUUIDCreateString(kCFAllocatorDefault, uuid);

  CFRelease(uuid);

  return uuidString;
}
@end
