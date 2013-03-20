#import "DSCFLoatDictionary.h"

CGFloat CGFloatNotFound = CGFLOAT_MAX;

@implementation DSCFLoatDictionary

- (void)dealloc
{
  for (NSInteger i = 0; i < _objectsCapacity; i++) 
  {
    free(_values[i]);
  }
  
  free(_values);
  
}

- (id)initWithCapacity:(NSInteger)theCapacity
    capacityForObjects:(NSInteger)theObjectsCapacity
{
  self = [super init];
  
  if (self) 
  {
    _capacity = theCapacity;
    _objectsCapacity = theObjectsCapacity;
    
    _values = malloc(sizeof(*_values)*theObjectsCapacity);
    for (NSInteger i = 0; i < theObjectsCapacity; i++) 
    {
      _values[i] = malloc(sizeof(**_values)*theCapacity);
      for (unsigned idx = 0; idx < theCapacity; idx++)
      {
        _values[i][idx] = CGFloatNotFound;
      }
    }
    
    _objects = [[NSMutableArray alloc] initWithCapacity:theObjectsCapacity];
  }
  
  return self;
}

- (void)addValue:(CGFloat)theValue
       forObject:(id)theObject
         atIndex:(NSInteger)theIndex 
{
  NSAssert(theObject != nil, @"Shouldn't be nil");
  
  NSInteger indexOf_theObject = [_objects indexOfObject:theObject];
  if (indexOf_theObject == NSNotFound) 
  {
    [_objects addObject:theObject];
    indexOf_theObject = [_objects indexOfObject:theObject];
    NSAssert(indexOf_theObject != NSNotFound, @"Something wrong with array");
  } 
  
  if (indexOf_theObject < _objectsCapacity 
      && theIndex < _capacity) {
    _values[indexOf_theObject][theIndex] = theValue;
  } 
  else 
  {
    NSAssert(NO, @"Logic error");
  }
}

- (CGFloat)valueForObject:(id)theObject
                  atIndex:(NSInteger)theIndex
{
  if (theObject == nil) 
  {
    return CGFloatNotFound;
  }
  
  NSInteger indexOf_theObject = [_objects indexOfObject:theObject];
  if (indexOf_theObject == NSNotFound) 
  {
    return CGFloatNotFound;
  } 
  
  if (indexOf_theObject < _objectsCapacity 
      && theIndex < _capacity && theIndex >= 0) 
  {
    CGFloat foundedValue = _values[indexOf_theObject][theIndex];
    return foundedValue;
  } 
  else 
  {
    return CGFloatNotFound;
  }  
}

- (CGFloat)maxForObject:(id)theObject
{
  NSParameterAssert(theObject != nil);
  NSInteger indexOf_theObject = [_objects indexOfObject:theObject];
  if (indexOf_theObject == NSNotFound) 
  {
    return CGFloatNotFound;
  } 
  
  CGFloat max = -CGFLOAT_MAX;
  for (NSInteger index = 0; index < _capacity; index++) 
  {    
    CGFloat foundedValue = _values[indexOf_theObject][index];
    if (foundedValue != CGFloatNotFound) {
      max = MAX(max, foundedValue);
    }
  }
  
  return max;
}

- (CGFloat)minForObject:(id)theObject
{
  NSParameterAssert(theObject != nil);
  
  NSInteger indexOf_theObject = [_objects indexOfObject:theObject];
  if (indexOf_theObject == NSNotFound) 
  {
    return CGFloatNotFound;
  } 
  
  CGFloat min = CGFLOAT_MAX;
  for (NSInteger index = 0; index < _capacity; index++) 
  {    
    CGFloat foundedValue = _values[indexOf_theObject][index];
    min = MIN(min, foundedValue);
  }
  
  return min;
}

- (CGFloat)maxForObject:(id)theObject
             startIndex:(NSInteger)theStartIndex
               endIndex:(NSInteger)theEndIndex
{
  NSParameterAssert(theObject != nil);
  
  if (theEndIndex >= _capacity) {
    theEndIndex = _capacity - 1;
  }
  
  if (theStartIndex < 0)
  {
    theStartIndex = 0;
  }
  
  NSInteger indexOf_theObject = [_objects indexOfObject:theObject];
  if (indexOf_theObject == NSNotFound) 
  {
    return CGFloatNotFound;
  } 
  
  CGFloat max = -CGFLOAT_MAX;
  for (NSInteger index = theStartIndex; index <= theEndIndex; index++) 
  {        
    CGFloat foundedValue = _values[indexOf_theObject][index];
    if (foundedValue != CGFloatNotFound) {
      max = MAX(max, foundedValue);
    }
  }
  
  return max;
}

- (CGFloat)minForObject:(id)theObject
             startIndex:(NSInteger)theStartIndex
               endIndex:(NSInteger)theEndIndex
{
  NSParameterAssert(theObject != nil);
  
  if (theEndIndex >= _capacity) {
    theEndIndex = _capacity - 1;
  }
  
  if (theStartIndex < 0)
  {
    theStartIndex = 0;
  }
  
  NSInteger indexOf_theObject = [_objects indexOfObject:theObject];
  if (indexOf_theObject == NSNotFound) 
  {
    return CGFloatNotFound;
  } 
  
  CGFloat min = CGFLOAT_MAX;
  for (NSInteger index = theStartIndex; index <= theEndIndex; index++) 
  {    
    CGFloat foundedValue = _values[indexOf_theObject][index];
    min = MIN(min, foundedValue);
  }
  
  return min;
}


- (NSInteger)capacity
{
  return _capacity;
}
@end
