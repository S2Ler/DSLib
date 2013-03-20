
#import "NSObject+DSAdditions.h"
#import "objc/runtime.h"

@implementation NSObject (DSAdditions)
#if OVERWRITE_DESCRIPTION
- (NSString *)description
#else
- (NSString *)longDescription
#endif
{
  return [self __descriptionWithoutObjects:nil];
}

- (NSString *)__descriptionWithoutObjects:(NSArray *)objectsToExclude
{
  NSMutableString *description = [NSMutableString stringWithFormat:@"\nDescription for class: %@\n\tparams:",
                                                                   NSStringFromClass([self class])];

  unsigned int count;
  objc_property_t *properties = class_copyPropertyList([self class], &count);

  for (unsigned int idx = 0; idx < count; idx++) {
    const char *propertyName_cStr = property_getName(properties[idx]);
    NSString *propertyName = [NSString stringWithUTF8String:propertyName_cStr];

    id propertyValue = [self valueForKey:propertyName];

    BOOL shouldExcludePropertyValue = NO;
    for (id excludeObject in objectsToExclude) {
      if (excludeObject == propertyValue) {
        shouldExcludePropertyValue = YES;
        break;
      }
    }

    if (!shouldExcludePropertyValue) {
      NSString *propertyDescription = propertyValue;

      [description appendFormat:@"\n\t\t%@: %@",
                                propertyName,
                                propertyDescription];
    }
  }
  [description appendFormat:@"\n\tend_params"];

  free(properties);

  return description;
}

+ (NSArray *)propertyNames
{
  NSMutableArray *propertyNames = [NSMutableArray array];

  unsigned int outCount, i;

  objc_property_t *properties = class_copyPropertyList([self class], &outCount);

  for (i = 0; i < outCount; i++) {
    objc_property_t property = properties[i];
    const char *propName = property_getName(property);
    if (propName) {
      NSString *propertyName = [NSString stringWithUTF8String:propName];
      [propertyNames addObject:propertyName];
    }
  }
  free(properties);

  return propertyNames;
}
@end
