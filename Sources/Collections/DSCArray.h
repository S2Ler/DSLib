#import <Foundation/Foundation.h>


@interface DSCArray : NSObject {
  unsigned int _capacity;
  unsigned int _count;
  float *_values;
}

- (id)initWithCapacity:(unsigned int)theCapacity;
- (void)addValue:(float)theValue;
- (void)setValue:(float)theValue
         atIndex:(unsigned int)theIndex;
- (float)valueAtIndex:(unsigned int)theIndex;
- (unsigned int)capacity;
- (unsigned int)count;
- (void)clear;

- (float)sumWithRange:(NSRange)theRange;

@end
