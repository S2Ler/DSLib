#pragma mark - include
#import "DSQueue.h"

#pragma mark - props
@interface DSQueue() 
@property (nonatomic, copy) NSMutableArray *queue;
@end

#pragma mark - Private
@interface DSQueue(Private)
/** Update the state of the isFull_ variable */
- (void)updatedIsFullVariable;
@end

@implementation DSQueue
#pragma mark - synth
@synthesize isFull = isFull_;
@synthesize queue = queue_;


#pragma mark ----------------inits----------------
- (id)initWithCapacity:(NSUInteger)theCapacity {
	self = [super init];
	if (self != nil) {
		queue_ = [[NSMutableArray alloc] initWithCapacity:theCapacity];
    capacity_ = theCapacity;
    isFull_ = NO;
	}
	return self;
}

#pragma mark ----------------queue----------------
- (id)pop
{
  id lastObject = [queue_ lastObject];
  if (lastObject != nil) {
    [queue_ removeLastObject];
	}
  [self updatedIsFullVariable];

  return lastObject;
}

- (id)top {
  return [queue_ lastObject];
}

- (id)first {
  if ([queue_ count] > 0) {
    return [queue_ objectAtIndex:0];
  } else {
    return nil;
  }
}

- (void)push:(id)anObject
{
  if ([queue_ count] == capacity_) {
    [queue_ removeObjectAtIndex:0];
    [self updatedIsFullVariable];
  }
	[queue_ addObject:anObject];
  [self updatedIsFullVariable];
}

- (void)removeAll {
	[queue_ removeAllObjects];
  [self updatedIsFullVariable];
}

- (NSUInteger)count {
	return [queue_ count];
}

- (NSUInteger)capacity {
  return capacity_;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
	[aCoder encodeObject:queue_
                forKey:@"queue"];
}

- (id)initWithCoder:(NSCoder *)aDecoder {	
	queue_ = [aDecoder decodeObjectForKey:@"queue"];
	return self;
}

- (NSEnumerator *)objectEnumerator {
  return [queue_ objectEnumerator];
}

- (NSEnumerator *)reverseObjectEnumerator {
  return [queue_ reverseObjectEnumerator];
}

- (void)updatedIsFullVariable {
  [self setIsFull:([self count] >= [self capacity])];
}

- (id)copyWithZone:(NSZone *)zone
{
  DSQueue *copy = [[[self class] allocWithZone:zone] initWithCapacity:capacity_];
  [copy setQueue:queue_];
  return copy;
}                               
@end
