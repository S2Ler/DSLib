
#import "NSObject+DSAdditions.h"
#import "objc/runtime.h"
#import "MARTNSObject.h"
#import "RTProperty.h"
#import "DSMacros.h"

@implementation NSObject (DSAdditions)

+ (void)load
{
#if OVERWRITE_DESCRIPTION
  SWAP_METHODS(@selector(description), @selector(longDescription));
#endif
}

- (NSString *)longDescription
{
  return [self __descriptionWithoutObjects:nil];
}

- (NSString *)__descriptionWithoutObjects:(NSArray *)objectsToExclude
{
  NSMutableString *description = [NSMutableString stringWithFormat:@"{\"class\": \"%@\", \"params\":{",
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
      NSString *propertyDescription = [propertyValue description];

      [description appendFormat:@"\"%@\": \"%@\"",
                                propertyName,
                                propertyDescription];
      if (idx < count - 1) {
        [description appendString:@", "];
      }
    }
  }
  [description appendFormat:@"}}"];

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

static char OBJECT_USER_INFO_KEY;

- (NSMutableDictionary*) objectUserInfo
{
	NSMutableDictionary* objectUserInfo = objc_getAssociatedObject(self, &OBJECT_USER_INFO_KEY);
  
	if(objectUserInfo == nil) {
		objectUserInfo = [[NSMutableDictionary alloc] init];
		objc_setAssociatedObject(self, &OBJECT_USER_INFO_KEY, objectUserInfo, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
	}
  
	return objectUserInfo;
}

+ (NSArray *)propertiesPassingTest:(BOOL(^)(Class propertyClass))test
{
  NSMutableArray *parseProperties = [NSMutableArray array];
  NSArray *properties = [self rt_properties];
  
  for (RTProperty *property in properties) {
    NSString *propertyTypeEncoded = [property typeEncoding];
    
    //NOTE: propertyTypeEncoded for Parse class looks like: @"@"CLASS_NAME"", so we need to remove @"" in order to get class name
    propertyTypeEncoded = [propertyTypeEncoded stringByTrimmingCharactersInSet:
                           [NSCharacterSet characterSetWithCharactersInString:@"@\""]];
    Class propertyClass = NSClassFromString(propertyTypeEncoded);
    
    if (propertyClass && test(propertyClass)) {
      [parseProperties addObject:property];
    }
  }
  
  return parseProperties;
}

- (NSDictionary *)keysAndValuesForPropertiesPassingTest:(BOOL (^)(Class propertyClass))test
{
  return [self keysAndValuesForPropertiesPassingTest:test
                                 includeSuperClasses:NO
                                        includeDepth:0];
}

- (NSDictionary *)keysAndValuesForPropertiesPassingTest:(BOOL (^)(Class propertyClass))test
                                    includeSuperClasses:(BOOL)includeSuperClasses
                                           includeDepth:(NSUInteger)depth
{
  NSMutableDictionary *keysAndValues = [NSMutableDictionary dictionary];
  [self __keysAndValuesForPropertiesPassingTest:test
                            includeSuperClasses:includeSuperClasses
                                   currentClass:[self class]
                                   includeDepth:depth
                                  keysAndValues:keysAndValues];
  return keysAndValues;
}

- (NSDictionary *)__keysAndValuesForPropertiesPassingTest:(BOOL (^)(Class propertyClass))test
                                      includeSuperClasses:(BOOL)includeSuperClasses
                                             currentClass:(Class)currentClass
                                             includeDepth:(NSUInteger)depth
                                            keysAndValues:(NSMutableDictionary *)keysAndValues
{
  NSArray *properties = [currentClass propertiesPassingTest:test];
  
  for (RTProperty *property in properties) {
    NSString *propertyName = [property name];
    id value = [self valueForKey:propertyName];
    if (!value) {
      value = [NSNull null];
    }
    
    keysAndValues[propertyName] = value;
  }
  
  if (includeSuperClasses && currentClass && depth > 0) {
    [self __keysAndValuesForPropertiesPassingTest:test
                              includeSuperClasses:includeSuperClasses
                                     currentClass:[currentClass superclass]
                                     includeDepth:depth - 1
                                    keysAndValues:keysAndValues];
  }
  
  return keysAndValues;
}

- (NSDictionary *)filterOutNonRespondingKeys:(NSDictionary *)keysAndValues
{
  NSMutableDictionary *filteredKeysAndValues = [NSMutableDictionary dictionary];
  for (NSString *key in [keysAndValues allKeys]) {
    
    if ([self respondsToSelector:NSSelectorFromString(key)]) {
      filteredKeysAndValues[key] = keysAndValues[key];
    }
  }
  return filteredKeysAndValues;
}
@end
