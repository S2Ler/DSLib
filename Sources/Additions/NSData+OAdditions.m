
#import <CommonCrypto/CommonDigest.h>
#import "NSData+OAdditions.h"


@implementation NSData (Additions)
- (NSData *)truncatedDataToLength:(NSUInteger)theLength
{
  theLength = MIN(theLength, [self length]);
  UInt8 bytes[theLength];
  [self getBytes:&bytes length:theLength];
  NSData *truncatedData = [[NSData alloc] initWithBytes:bytes length:sizeof(bytes)];
  return truncatedData;
}

- (NSData *)SHA256
{
  unsigned char hash[CC_SHA256_DIGEST_LENGTH];
  if (CC_SHA256([self bytes], (CC_LONG)[self length], hash)) {
    NSData *sha256 = [NSData dataWithBytes:hash length:CC_SHA256_DIGEST_LENGTH];
    return sha256;
  }

  return nil;
}

- (NSString *)hexString
{  
  NSUInteger capacity = [self length] * 2;
  NSMutableString *stringBuffer = [NSMutableString stringWithCapacity:capacity];
  const unsigned char *dataBuffer = [self bytes];
  NSInteger i;
  for (i = 0; i < [self length]; ++i) {
    [stringBuffer appendFormat:@"%02lX", (unsigned long)dataBuffer[i]];
  }
  return [NSString stringWithString:stringBuffer];
}

- (NSString *)deviceTokenString
{
  return [[[self description]
                 stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]]
                 stringByReplacingOccurrencesOfString:@" " withString:@""];
}


@end
