
#import <Foundation/Foundation.h>


/** A set of usefull functions to query object from NSArray */
@interface NSArray(ObjectsQuery) 

/** Get specific number of items from array.
 \param theFrom the index of the first object to query
 \param theCount number of items including theFrom to add to the query
 \return array with objects from the target array */
- (NSArray *)objectsFromIndex:(NSUInteger)theFrom
                        count:(NSUInteger)theCount;
@end
