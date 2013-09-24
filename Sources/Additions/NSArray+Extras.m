
#import "NSArray+Extras.h"

@implementation NSArray (Extras)

-(NSUInteger)indexForInsertingObject:(id)anObject 
										sortedUsingBlock: (NSInteger (^)(id a, id b)) compare;
{
	NSUInteger index = 0;
	NSUInteger topIndex = [self count];
	while ((NSUInteger)index < topIndex)
	{
		NSUInteger midIndex = ((NSUInteger)index + topIndex) / 2;
		id testObject = [self objectAtIndex:midIndex];
		if (compare(anObject, testObject) < 0) 
		{
			index = midIndex + 1;
		} 
		else 
		{
			topIndex = midIndex;
		}
	}
	return index;
}

-(NSInteger)indexForEqualObject:(id)anObject equalUsingBlock: (NSInteger (^)(id a, id b)) compare;
{
	NSInteger index = 0;
	NSInteger topIndex = [self count];
	while ((NSInteger)index < topIndex)
	{
		NSInteger midIndex = ((NSInteger)index + topIndex) / 2;
		id testObject = [self objectAtIndex:midIndex];
		NSInteger resCompare = compare(anObject, testObject);
		if(!resCompare)
			return index;
		if (resCompare < 0) 
		{
			index = midIndex + 1;
		} 
		else 
		{
			topIndex = midIndex;
		}
	}
	return NSNotFound;
}

- (id)firstObject
{
  if ([self count] > 0) {
    return [self objectAtIndex:0];
  } else {
    return nil;
  }
}

- (id)ds_objectAtIndex:(NSUInteger)index
{
  if ([self count] > index) {
    return [self objectAtIndex:index];
  } else {
    return nil;
  }
}

- (NSArray *)imagesArray
{
	NSMutableArray *imagesArray = [NSMutableArray array];
	
	for (NSString *currentString in self)
	{
		[imagesArray addObject:[UIImage imageNamed:currentString]];
	}
	
	return imagesArray;
}

- (NSArray *)groupObjectsByKeyPath:(NSString *)keyPath
{
    NSMutableArray *groups = [NSMutableArray array];
    
    NSMutableArray *(^groupWithKeyPathValue) (id) = ^NSMutableArray *(id value)
    {
        for (NSMutableArray *group in groups) {
            id anyObject = [group lastObject];
            if ([[anyObject valueForKeyPath:keyPath] isEqual:value]) {
                return group;
            }
        }

        NSMutableArray *newGroup = [NSMutableArray array];
        [groups addObject:newGroup];
        return newGroup;
    };

    //Start reading here
    for (id object in self) {
        NSMutableArray *group = groupWithKeyPathValue([object valueForKeyPath:keyPath]);
        [group addObject:object];
    }

    return groups;
}

@end
