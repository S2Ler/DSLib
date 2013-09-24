
#import "DSArrayChangeCalculator.h"
#import "DSArrayChange.h"


@implementation DSArrayChangeCalculator {

}
- (NSArray *)calculateChangesFromArray:(NSArray *)initialArray toArray:(NSArray *)newArray {
    NSMutableArray *changes = [NSMutableArray array];

    void (^insertChangeWithTypeAtIndex)(DSArrayChangeType, NSUInteger, NSUInteger)
            = ^(DSArrayChangeType changeType, NSUInteger index, NSUInteger toIndex) {
        [changes addObject:[DSArrayChange arrayChangeWithType:changeType index:index toIndex:toIndex]];
    };

    [initialArray enumerateObjectsUsingBlock:^(id initialObject, NSUInteger idx, BOOL *stop) {
        NSUInteger newIdx = [newArray indexOfObject:initialObject];
        if (newIdx == idx) {
            //insertChangeWithTypeAtIndex(DSArrayChangeTypeUpdate, idx, NSNotFound);
            //TODO: Find a way to check if update needed for item
        }
        else if (newIdx == NSNotFound) {
            insertChangeWithTypeAtIndex(DSArrayChangeTypeRemove, idx, NSNotFound);
        }
        else {
            insertChangeWithTypeAtIndex(DSArrayChangeTypeMove, idx, newIdx);
        }
    }];

    //find insert objects
    [newArray enumerateObjectsUsingBlock:^(id obj, NSUInteger newIdx, BOOL *stop) {
        if (!initialArray || [initialArray indexOfObject:obj] == NSNotFound) {
            insertChangeWithTypeAtIndex(DSArrayChangeTypeInsert, newIdx, NSNotFound);
        }
    }];
    
    return changes;
}

@end
