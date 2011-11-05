#import "DSCArray.h"


@implementation DSCArray
- (void)dealloc
{
  free(_values);
  [super dealloc];
}

- (id)initWithCapacity:(unsigned int)theCapacity 
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
         atIndex:(unsigned int)theIndex
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

- (float)valueAtIndex:(unsigned int)theIndex
{
  if (theIndex < _count) 
  {
    return _values[theIndex];
  } else {
    NSAssert(NO, @"Check the values");
    return -CGFLOAT_MIN;
  }
}

- (unsigned int)capacity
{
  return _capacity;
}

- (unsigned int)count
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
    for (int idx = theRange.location;
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
