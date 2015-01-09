
@import Foundation;

@interface NSData (Additions)
- (NSData *)truncatedDataToLength:(NSUInteger)theLength;

- (NSData *)SHA256;

- (NSString *)hexString;

- (NSString *)deviceTokenString;
@end
