
@import Foundation;
#import "objc/runtime.h"

@interface DSRuntimeHacker : NSObject

- (id)initWithClient:(id)clientObject;
+ (id)hackerWithClient:(id)client;
- (NSString *)propertyName:(id)property;
- (NSArray *)allProperties;
- (NSArray *)allPropertyNames;
/** Doesn't include superclasses of propertyClass.
 \important if objects properties have constant strings and you try to get them with
 propertyClass == NSString you will fail. TODO: Find workaround
 */
- (NSArray *)allPropertiesOfClass:(Class)propertyClass;
- (NSArray *)allPropertiesOfClass:(Class)propertyClass
              includeSuperclasses:(BOOL)includeSuperclasses;

- (NSString *)classNameForObject:(id)object;

/** Only properties like NSNumber *name; NSArray *name; and so on are supported */
- (Class)classForProperty:(objc_property_t)theProperty;
@end
