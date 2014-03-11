
#pragma mark - include
#import "DSRuntimeHacker.h"
#include "CStringsFunctions.h"

#define PROPERTY_NAME_KEY @"name"
#define PROPERTY_TYPE_KEY @"type"

typedef BOOL (^__class_block_t)(Class theClass);

#pragma mark - private
@interface DSRuntimeHacker()  
@property (nonatomic, weak) id client;
@property (nonatomic, assign) Ivar *ivars;
@property (nonatomic, assign) unsigned int numIvars;

- (NSDictionary *)parsePropertyAttributes:(objc_property_t)theProperty;

@end

@implementation DSRuntimeHacker
@synthesize client = _client;
@synthesize ivars = _ivars;
@synthesize numIvars = _numIvars;

- (void)dealloc
{
  free(_ivars);
}

- (id)initWithClient:(id)clientObject {
  self = [super init];
  if (self) {
    _client = clientObject;
    _ivars = class_copyIvarList([_client class], &_numIvars);
  }
  return self;
}

+ (id)hackerWithClient:(id)client
{
  return [[DSRuntimeHacker alloc] initWithClient:client];
}


#pragma mark - Private
- (NSArray *)convertIvarsToArray:(Ivar *)ivars
                     classFilter:(__class_block_t)theFilter
                           count:(int)numIvars 
{
  NSMutableArray *ivarsToReturn = [NSMutableArray new];
  
  for(int i = 0; i < numIvars; i++) {
    id property = object_getIvar(_client, ivars[i]);
    if (theFilter([property class]) == TRUE) 
    {
      if (property != nil) {
        [ivarsToReturn addObject:property];
      }
    }
  }
  
  return ivarsToReturn;
}


- (NSArray *)convertIvarsToArray:(Ivar *)ivars 
                        forClass:(Class)class
             includeSuperclasses:(BOOL)includeSuperclasses
                           count:(int)numIvars 
{
  NSMutableArray *ivarsToReturn = [NSMutableArray new];
  
  for(int i = 0; i < numIvars; i++) {
    id property = object_getIvar(_client, ivars[i]);
    if ((includeSuperclasses == YES && [property isKindOfClass:class] == YES) ||
        (includeSuperclasses == NO && [property isMemberOfClass:class] == YES)) 
    {
      [ivarsToReturn addObject:property]; 
    }
  }
  
  return ivarsToReturn;
}


#pragma mark - Public
-(NSString *)propertyName:(id)property {  
  NSString *key=nil;
  
  for(int i = 0; i < _numIvars; i++)
    if ((object_getIvar(_client, _ivars[i]) == property)) {
      key = [NSString stringWithUTF8String:ivar_getName(_ivars[i])];
      break;
    }
  
  return key;
} 

- (NSArray *)allProperties
{
  NSArray *ivarsToReturn = [self convertIvarsToArray:_ivars
                                         classFilter:^BOOL(__unsafe_unretained Class theClass) {
                                           return YES;
                                         } count:_numIvars];  
  return ivarsToReturn;
}

- (NSArray *)allPropertyNames
{
  NSMutableArray *names = [NSMutableArray array];
  
  for(int i = 0; i < _numIvars; i++) {
    NSString *key = [NSString stringWithUTF8String:ivar_getName(_ivars[i])];
    [names addObject:key];
  }
  
  return names;
}

- (NSArray *)allPropertiesOfClass:(Class)propertyClass {
  return [self allPropertiesOfClass:propertyClass includeSuperclasses:NO];
}

- (NSArray *)allPropertiesOfClass:(Class)propertyClass
              includeSuperclasses:(BOOL)includeSuperclasses
{
  NSArray *ivarsToReturn = [self convertIvarsToArray:_ivars
                                            forClass:propertyClass
                                 includeSuperclasses:includeSuperclasses
                                               count:_numIvars];
  
  return ivarsToReturn;  
}

- (NSString *) classNameForObject : (id) object {
	return [NSString stringWithCString:object_getClassName(object) 
                            encoding:NSUTF8StringEncoding];
}

- (Class)classForProperty:(objc_property_t)theProperty
{
  NSDictionary *propertyAttributes = [self parsePropertyAttributes:theProperty];
  NSString *typeName = [propertyAttributes objectForKey:PROPERTY_TYPE_KEY];
  Class propertyClass = NSClassFromString(typeName);
  
  if (propertyClass) {
    return propertyClass;
  } else {
    return NULL;
  }
}

#pragma mark - helpers
- (NSDictionary *)parsePropertyAttributes:(objc_property_t)theProperty
{
  NSMutableDictionary *parsedAttributes = [NSMutableDictionary dictionary];
  
  unsigned int count;
  objc_property_attribute_t *attrs = property_copyAttributeList(theProperty, &count);
  
  for (int idx = 0; idx < count; idx++) {
    const char *name_s = attrs[idx].name;
    const char *value_s = attrs[idx].value;
    
    if (strcmp(name_s, "T") == 0) {
      char *type_name_s = removeChars("@\"", value_s);
      NSString *type_name = [NSString stringWithUTF8String:type_name_s];
      free(type_name_s);
      [parsedAttributes setObject:type_name forKey:PROPERTY_TYPE_KEY];
    } else if (strcmp(name_s, "V") == 0) {
      char *property_name_s = removeChars("V", value_s);
      NSString *property_name = [NSString stringWithUTF8String:property_name_s];
      [parsedAttributes setObject:property_name forKey:PROPERTY_NAME_KEY];
      free(property_name_s);
    }
  }        
  
  return parsedAttributes;
}

@end
