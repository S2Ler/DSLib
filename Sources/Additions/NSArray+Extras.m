
#import "NSArray+Extras.h"
@import UIKit;

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
         sortedWithSortDescriptors:(NSArray *)sortDescriptors
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
  
  NSArray *objects = self;
  if ([sortDescriptors count] > 0) {
    objects = [self sortedArrayUsingDescriptors:sortDescriptors];
  }
  
  for (id object in objects) {
    NSMutableArray *group = groupWithKeyPathValue([object valueForKeyPath:keyPath]);
    [group addObject:object];
  }
  
  return groups;
}

- (NSArray *)groupObjectsByKeyPath:(NSString *)keyPath
{
  return [self groupObjectsByKeyPath:keyPath sortedWithSortDescriptors:nil];
}

- (NSDictionary *)mapObjectsByKeyPath:(NSString *)keyPath
{
  return [self mapObjectsByKeyPath:keyPath sortedWithSortDescriptors:nil];
}

- (NSDictionary *)mapObjectsByKeyPath:(NSString *)keyPath
            sortedWithSortDescriptors:(NSArray *)sortDescriptors
{
  NSArray *groupedObjects = [self groupObjectsByKeyPath:keyPath sortedWithSortDescriptors:sortDescriptors];
  
  NSMutableDictionary *mappedObjects = [NSMutableDictionary dictionary];
  
  for (NSArray *group in groupedObjects) {
    id<NSObject, NSCopying> mapObject = [[group firstObject] valueForKeyPath:keyPath];
    NSAssert([mapObject conformsToProtocol:@protocol(NSCopying)], @"objects at keyPath should conform to NSCopying protocol");
    [mappedObjects setObject:group forKey:mapObject];
  }
  
  return mappedObjects;
}

- (NSUInteger)countObject:(id)object
{
  __block NSUInteger count = 0;
  [self enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
    if ([object isEqual:obj]) {
      count++;
    }
  }];
  
  return count;
}

- (NSArray *)filteredArrayUsingBlock:(BOOL(^)(id evaluatedObject))block;
{
  return [self filteredArrayUsingPredicate:
          [NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
    return block(evaluatedObject);
  }]];
}

- (id)randomObject
{
  id randomObject = [self count] ? self[arc4random_uniform((u_int32_t)[self count])] : nil;
  return randomObject;
}

- (NSArray *)map:(id(^)(id object))block
{
  NSMutableArray *results = [NSMutableArray arrayWithCapacity:[self count]];
  
  [self enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
    [results addObject:block(obj)];
  }];
  
  return results;
}

NSArray *mapFast(NSObject<NSFastEnumeration> *fastEnumerator, id(^block)(id))
{
  NSMutableArray *results = [NSMutableArray array];
  for (id object in fastEnumerator) {
    [results addObject:block(object)];
  }
  return results;
}
@end
