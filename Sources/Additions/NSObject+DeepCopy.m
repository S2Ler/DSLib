
#import "NSObject+DeepCopy.h"

@implementation NSObject (DeepCopy)
- (id)deepCopy
{
  if ([self conformsToProtocol:@protocol(NSCoding)]) {
    return [NSKeyedUnarchiver unarchiveObjectWithData:[NSKeyedArchiver archivedDataWithRootObject:self]];
  }
  else {
    return nil;
  }
}
@end
