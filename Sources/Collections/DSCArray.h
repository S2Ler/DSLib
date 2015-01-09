@import Foundation;


@interface DSCArray : NSObject 

- (id)initWithCapacity:(NSUInteger)theCapacity;
- (void)addValue:(float)theValue;
- (void)setValue:(float)theValue
         atIndex:(NSUInteger)theIndex;
- (float)valueAtIndex:(NSUInteger)theIndex;
- (NSUInteger)capacity;
- (NSUInteger)count;
- (void)clear;

- (float)sumWithRange:(NSRange)theRange;

@end
