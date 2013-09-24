
#import <Foundation/Foundation.h>

@interface NSDictionary (JSONDictionary)
- (NSString *)stringValueForKey:(NSString *)key;
- (NSNumber *)numberValueForKey:(NSString *)key;
@end
