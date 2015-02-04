@import Foundation;

/** First In First Out queue.
 If number of items exceed theCapacity defined in initWithCapacity: method the object which
 came first will be removed.
 If you use init: method the capacity will be NSUIntegerMax.
 */
@interface DSQueue : NSObject
<
NSCoding,
NSCopying,
NSFastEnumeration
> {  
  /** Maximum number of objects in queue */
  NSUInteger capacity_;
  
  /** Indicates whether capacity == count */
  BOOL isFull_;
}

/** \param theCapacity maximum number of items in queue */
- (id)initWithCapacity:(NSUInteger)theCapacity;
- (id)init;
+ (DSQueue *)queue;

/** \return Poped object from the queue. The one which pushed last. */
- (id)pop;

/** Adds theObject to the end of queue. 
 @param theObject nil values ignored
 */
- (void)push:(id)theObject;
/** Adds theObject to the beginning of the queue */
- (void)pushBack:(id)theObject;

- (void)pushObjectsFromArray:(NSArray *)array;

/** The top object in the queue */
- (id)top;

/** The first object in queue */
- (id)first;

/** Remove all objects from the queue */
- (void)removeAll;

/** Remove specific objects from queue */
- (void)removeObjectsInArray:(NSArray *)theObjects;

- (BOOL)containsObject:(id)anObject;

/** \return current number of objects in the queue */
- (NSUInteger)count;

/** \return maximum number of objects in the queue */
- (NSUInteger)capacity;

/** \return YES if capacity == count. 
 \note KVO is supported by this method */
- (BOOL)isFull;

/** \return enumerator for all objects in queue */
- (NSEnumerator *)objectEnumerator;

/** \return reversed enumerator for all objects in queue */
- (NSEnumerator *)reverseObjectEnumerator;

- (id)firstObjectWhichEqualsTo:(id)object;

- (void)filterWithPredicate:(NSPredicate *)predicate;

- (NSArray *)array;
@end

/** For internal and subclass use */
@interface DSQueue()
@property (assign) BOOL isFull;
@end
