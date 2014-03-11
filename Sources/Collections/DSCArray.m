#import "DSCArray.h"


@implementation DSCArray
{
  NSUInteger _capacity;
  NSUInteger _count;
  float *_values;
}

- (void)dealloc
{
  free(_values);
}

- (id)initWithCapacity:(NSUInteger)theCapacity
{
  self = [super init];
  
  if (self) 
  {
    _capacity = theCapacity;
    _values = malloc(theCapacity*sizeof(float));
    _count = 0;
  }
  
  return self;
}

- (void)addValue:(float)theValue
{
  if (_count < _capacity) 
  {
    _values[_count] = theValue;
    _count++;
  }
  else
  {
    NSAssert(NO, @"Check the values");
  }
}

- (void)setValue:(float)theValue
         atIndex:(NSUInteger)theIndex
{
  if (theIndex < _capacity && theIndex < _count) 
  {
    _values[theIndex] = theValue;
  }
  else
  {
    NSAssert(NO, @"Check the values");
  }
  
}

- (float)valueAtIndex:(NSUInteger)theIndex
{
  if (theIndex < _count) 
  {
    return _values[theIndex];
  } else {
    NSAssert(NO, @"Check the values");
    return -CGFLOAT_MIN;
  }
}

- (NSUInteger)capacity
{
  return _capacity;
}

- (NSUInteger)count
{
  return _count;
}

- (void)clear
{
  free(_values);
  _values = malloc(_capacity * sizeof(float));
}

- (float)sumWithRange:(NSRange)theRange
{
  if (theRange.location + theRange.length < [self count]) 
  {
    float sum = 0.0;
    for (NSUInteger idx = theRange.location;
         idx < theRange.location + theRange.length;
         idx++)
    {
      sum += [self valueAtIndex:idx];
    }
    return sum;
  } 
  else
  {
    NSAssert(NO, @"sumWithRange: theRange parameter is out of range");
    return NSNotFound;
  }
}

- (NSString *)description 
{
  NSMutableString *s = [NSMutableString string];
  for (int idx = 0; idx < [self count]; idx++) {
    [s appendFormat:@"%d:%f, ", idx, [self valueAtIndex:idx]];
  }
  return s;
}
@end
