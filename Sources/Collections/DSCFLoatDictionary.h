@import Foundation;

extern CGFloat CGFloatNotFound;

/** This is unresizable collection for storing CGFloat values 
 for given object with free access. */
@interface DSCFLoatDictionary : NSObject {
  NSInteger _capacity;
  NSInteger _objectsCapacity;
  CGFloat **_values;
  NSMutableArray *_objects;
}

- (NSInteger)capacity;

/**
 \param theCapacity Maximum number of values allowed to store 
 \param theObjectsCapacity Maximum number of different objects used in method
 addValue:forObject:atIndex:
 */
- (id)initWithCapacity:(NSInteger)theCapacity
    capacityForObjects:(NSInteger)theObjectsCapacity;

- (void)addValue:(CGFloat)theValue
       forObject:(id)theObject
         atIndex:(NSInteger)theIndex;

- (CGFloat)valueForObject:(id)theObject
                  atIndex:(NSInteger)theIndex;

- (CGFloat)maxForObject:(id)theObject;
- (CGFloat)minForObject:(id)theObject;

- (CGFloat)maxForObject:(id)theObject
             startIndex:(NSInteger)theStartIndex
               endIndex:(NSInteger)theEndIndex;
- (CGFloat)minForObject:(id)theObject
             startIndex:(NSInteger)theStartIndex
               endIndex:(NSInteger)theEndIndex;

@end
