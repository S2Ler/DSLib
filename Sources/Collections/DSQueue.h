#import <Foundation/Foundation.h>

/** First In First Out queue.
 If number of items exceed theCapacity defined in init method the object which
 came first will be removed. */
@interface DSQueue : NSObject
<
NSCoding,
NSCopying
> {
  /** queue storage object */
	NSMutableArray *queue_;
  
  /** Maximum number of objects in queue */
  NSUInteger capacity_;
  
  /** Indicates whether capacity == count */
  BOOL isFull_;
}

/** \param theCapacity maximum number of items in queue */
- (id)initWithCapacity:(NSUInteger)theCapacity;

/** \return Poped object from the queue. The one which pushed last. */
- (id)pop;

/** Adds theObject to the end of queue */
- (void)push:(id)theObject;

/** The top object in the queue */
- (id)top;

/** The first object in queue */
- (id)first;

/** Remove all objects from the queue */
- (void)removeAll;

/** \return current number of objects in the queue */
- (NSUInteger)count;

/** \return maximum number of objects in the queue */
- (NSUInteger)capacity;

/** \return YES if capacity == count. 
 NOTE: KVO is supported by this method */
- (BOOL)isFull;

/** \return enumerator for all objects in queue */
- (NSEnumerator *)objectEnumerator;

/** \return reversed enumerator for all objects in queue */
- (NSEnumerator *)reverseObjectEnumerator;

@end

/** For internal and subclass use */
@interface DSQueue()
@property (assign) BOOL isFull;
@end
