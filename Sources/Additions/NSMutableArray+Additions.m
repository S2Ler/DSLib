
#import "NSMutableArray+Additions.h"

@implementation NSMutableArray (Additions)
- (void)addObjectOrNil:(id)theObject
{
  if (theObject) {
    [self addObject:theObject];
  }
}
@end
