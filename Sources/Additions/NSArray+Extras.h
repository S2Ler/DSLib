
#import <Foundation/Foundation.h>

@interface NSArray (Extras)

- (NSUInteger)indexForInsertingObject:(id)anObject 
                     sortedUsingBlock:(NSInteger (^)(id a, id b))compare;

- (NSInteger)indexForEqualObject:(id)anObject
                 equalUsingBlock:(NSInteger (^)(id a, id b))compare;


- (id)firstObject;
- (id)ds_objectAtIndex:(NSUInteger)index;

- (NSArray *)imagesArray;
@end

