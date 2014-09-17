
#import <Foundation/Foundation.h>

@protocol DSArrayChangeApplier;

typedef enum {
    DSArrayChangeTypeMove,
    DSArrayChangeTypeUpdate,
    DSArrayChangeTypeRemove,
    DSArrayChangeTypeInsert
} DSArrayChangeType;

@interface DSArrayChange : NSObject

@property (nonatomic, assign, readonly) DSArrayChangeType type;
@property (nonatomic, assign, readonly) NSUInteger index;
@property (nonatomic, assign, readonly) NSUInteger toIndex;

/** For DSArrayChangeTypeMove it is better to use more convenient method initWithMoveFromIndex:toIndex:
 * */
- (id)initWithType:(DSArrayChangeType)type index:(NSUInteger)index toIndex:(NSUInteger)toIndex NS_DESIGNATED_INITIALIZER;

- (id)initWithMoveFromIndex:(NSUInteger)fromIndex toIndex:(NSUInteger)toIndex;

/**
* for DSArrayChangeTypeMove it is better to use more convenient method arrayChangeWithMoveFromIndex:toIndex:
*/
+ (id)arrayChangeWithType:(DSArrayChangeType)type index:(NSUInteger)index toIndex:(NSUInteger)toIndex;

+ (id)arrayChangeWithMoveFromIndex:(NSUInteger)fromIndex toIndex:(NSUInteger)toIndex;

@end
