
@import Foundation;

@interface NSArray (Extras)

- (NSUInteger)indexForInsertingObject:(id)anObject
                     sortedUsingBlock:(NSInteger (^)(id a, id b))compare;

- (NSInteger)indexForEqualObject:(id)anObject
                 equalUsingBlock:(NSInteger (^)(id a, id b))compare;


- (id)firstObject;
- (id)ds_objectAtIndex:(NSUInteger)index;

- (NSArray *)imagesArray;

/** @return array of arrays. Each array contains objects which has equal keyPath values */
- (NSArray *)groupObjectsByKeyPath:(NSString *)keyPath;

/** objects at keyPath should conform to NSCopying protocol */
- (NSDictionary *)mapObjectsByKeyPath:(NSString *)keyPath;
- (NSDictionary *)mapObjectsByKeyPath:(NSString *)keyPath
            sortedWithSortDescriptors:(NSArray *)sortDescriptors;
- (NSUInteger)countObject:(id)object;

- (NSArray *)filteredArrayUsingBlock:(BOOL(^)(id evaluatedObject))block;

- (id)randomObject;

- (NSArray *)map:(id(^)(id object))block;
@end

NSArray *mapFast(NSObject<NSFastEnumeration> *fastEnumerator, id(^block)(id));
