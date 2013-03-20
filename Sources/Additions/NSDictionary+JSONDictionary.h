//
//  NSDictionary(JSONDictionary)
//  RapidRecruitApp
//
//  Created by Alexander Belyavskiy on 12/20/12.

#import <Foundation/Foundation.h>

@interface NSDictionary (JSONDictionary)
- (NSString *)stringValueForKey:(NSString *)key;
- (NSNumber *)numberValueForKey:(NSString *)key;
@end
