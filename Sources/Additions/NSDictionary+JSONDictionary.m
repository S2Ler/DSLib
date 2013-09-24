
#import "NSDictionary+JSONDictionary.h"


@implementation NSDictionary (JSONDictionary)
- (NSString *)stringValueForKey:(NSString *)key
{
  id value = [self valueForKey:key];
  if ([value isKindOfClass:[NSString class]]) {
    return value;
  }
  else if ([value isKindOfClass:[NSNull class]]) {
    return nil;
  }
  else {
    return [NSString stringWithFormat:@"%@", value];
  }
}

- (NSNumber *)numberValueForKey:(NSString *)key
{
  id value = [self valueForKey:key];
  if ([value isKindOfClass:[NSNumber class]]) {
    return value;
  }
  else {
    return nil;
  }
}

@end
