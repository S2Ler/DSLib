//
//  DSArrayChange
//  uPrintX
//
//  Created by Alexander Belyavskiy on 6/3/13.

#import "DSArrayChange.h"
#import "DSArrayChangeApplier.h"

@interface DSArrayChange ()
@property(nonatomic, assign) DSArrayChangeType type;

@property(nonatomic, assign) NSUInteger index;
@property(nonatomic, assign) NSUInteger toIndex;

@end

@implementation DSArrayChange {

}

- (id)initWithMoveFromIndex:(NSUInteger)fromIndex toIndex:(NSUInteger)toIndex
{
    return [self initWithType:DSArrayChangeTypeMove
                        index:fromIndex
                      toIndex:toIndex];
}

- (id)initWithType:(DSArrayChangeType)type index:(NSUInteger)index toIndex:(NSUInteger)toIndex {
    if (toIndex == NSNotFound) {
        NSAssert(type != DSArrayChangeTypeMove, @"Use: ", nil);
    }

    self = [super init];
    if (self) {
        _type = type;
        _index = index;
        _toIndex = toIndex;
    }
    return self;
}

+ (id)arrayChangeWithType:(DSArrayChangeType)type index:(NSUInteger)index toIndex:(NSUInteger)toIndex
{
    return [[self alloc] initWithType:type index:index toIndex:toIndex];
}

+ (id)arrayChangeWithMoveFromIndex:(NSUInteger)fromIndex toIndex:(NSUInteger)toIndex
{
    return [[self alloc] initWithMoveFromIndex:fromIndex
                                       toIndex:toIndex];
}

- (NSString *)description {
    return [NSString stringWithFormat:@"DSArrayChange of type: %d index: %d to index: %d", [self type], [self index], [self toIndex]];
}
@end
