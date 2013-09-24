
#import <CoreLocation/CoreLocation.h>
#import "DSCLPlacemarkTransformer.h"

@implementation DSCLPlacemarkTransformer
+ (BOOL)allowsReverseTransformation
{
  return YES;
}

+ (Class)transformedValueClass
{
  return [NSData class];
}

- (id)transformedValue:(id)value
{
  CLPlacemark *placemark = value;
  return [NSKeyedArchiver archivedDataWithRootObject:placemark];
}

- (id)reverseTransformedValue:(id)value
{
  return [NSKeyedUnarchiver unarchiveObjectWithData:value];
}

@end
