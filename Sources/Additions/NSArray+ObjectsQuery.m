
#import "NSArray+ObjectsQuery.h"


@implementation NSArray(ObjectsQuery)
- (NSArray *)objectsFromIndex:(NSUInteger)theFrom
					  count:(NSUInteger)theCount 
{
	return [self objectsAtIndexes:[NSIndexSet indexSetWithIndexesInRange:
                                 NSMakeRange(theFrom, theCount)]];
}

- (id)firstObjectWhichEqualsTo:(id)object
{
  return [self objectAtIndex:[self indexOfObject:object]];
}

- (NSArray *)extractKeypaths:(NSArray *)keypaths
{
  NSMutableArray *extractedKeypaths = [NSMutableArray array];

  if ([keypaths count] == 0) {
    return extractedKeypaths;
  }

  if ([keypaths count] == 1) {
    for (id object in self) {
      [extractedKeypaths addObject:[object valueForKeyPath:[keypaths lastObject]]];
    }
  }
  else {
    for (id object in self) {
      NSMutableDictionary *values = [NSMutableDictionary dictionary];
      for (NSString *keypath in keypaths) {
        [values setValue:[object valueForKeyPath:keypath] forKey:keypath];
      }
      [extractedKeypaths addObject:values];
    }
  }

  return extractedKeypaths;
}


@end
