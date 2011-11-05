
#import "NSArray+ObjectsQuery.h"


@implementation NSArray(ObjectsQuery)
- (NSArray *)objectsFromIndex:(NSUInteger)theFrom
					  count:(NSUInteger)theCount 
{
	return [self objectsAtIndexes:[NSIndexSet indexSetWithIndexesInRange:
                                 NSMakeRange(theFrom, theCount)]];
}

@end
