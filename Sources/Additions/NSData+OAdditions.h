//
//  NSData(OAdditions)
//
//  Created by Alexander Belyavskiy on 3/19/12

#import <Foundation/Foundation.h>

@interface NSData (Additions)
- (NSData *)truncatedDataToLength:(NSUInteger)theLength;

- (NSData *)SHA256;

- (NSString *)hexString;

- (NSString *)deviceTokenString;
@end
