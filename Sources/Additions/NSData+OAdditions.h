
#import <Foundation/Foundation.h>

@interface NSData (Additions)
- (NSData *)truncatedDataToLength:(NSUInteger)theLength;

- (NSData *)SHA256;

- (NSString *)hexString;

- (NSString *)deviceTokenString;
@end
