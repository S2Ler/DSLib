//
//  DSEntityDefinition
//
//  Created by Alexander Belyavskiy on 5/7/12.

#pragma mark - include
#import "DSEntityDefinition.h"
#import "NSDate+OAddittions.h"
#import "NSString+Extras.h"
#import "DSWebServiceConfiguration.h"
#import "DSMacros.h"

#pragma mark - private
@interface DSEntityDefinition ()
@property (nonatomic, strong) NSMutableDictionary *dictionary;
+ (NSString *)classPrefix;
@end

@implementation DSEntityDefinition
@synthesize dictionary = _dictionary;
@dynamic recID;


- (id)initWithDictionary:(NSDictionary *)theDictionary
{
  self = [super init];
  if (self) {
    _dictionary = [theDictionary mutableCopy];
    if (!_dictionary) {
      _dictionary = [NSMutableDictionary dictionary];
    }
  }
  return self;
}

- (id)init
{
  return [self initWithDictionary:nil];
}

+ (id)definitionWithDictionary:(NSDictionary *)theDictionary
{
  return [[self alloc] initWithDictionary:theDictionary];
}

+ (Class)entityDefinitionClassForObject:(NSManagedObject *)theEntity
{
  NSString *entityName = [NSStringFromClass([theEntity class]) stringByRemovingPrefix:[self classPrefix]];
  return [self entityDefinitionClassForEntityName:entityName];
}

+ (Class)entityDefinitionClassForEntityName:(NSString *)entityName
{
  NSString
    *entityDefinitionClassName = [NSString stringWithFormat:@"%@%@Definition", [self classPrefix], entityName];
  Class entityDefinitionClass = NSClassFromString(entityDefinitionClassName);
  return entityDefinitionClass;
}

+ (Class)entityDefinitionClassForRelationshipKey:(NSString *)theRelationshipKey
{
  NSString *entityName = [[theRelationshipKey stringByReplacingOccurrencesOfString:@"_collection"
                                                                        withString:@""] capitalizedString];
  return [self entityDefinitionClassForEntityName:entityName];
}

+ (id)definitionWithEntity:(NSManagedObject *)theEntity
{
  Class entityDefinitionClass = [self entityDefinitionClassForObject:theEntity];

  NSMutableDictionary *definitionDictionary = [self dictionaryFromEntity:theEntity];

  DSEntityDefinition *entityDefinition = [[entityDefinitionClass alloc] initWithDictionary:definitionDictionary];
  return entityDefinition;
}

+ (NSMutableDictionary *)dictionaryFromEntity:(NSManagedObject *)theObject
{
  return [self getDictionaryFromEntity:theObject doNotFollowRelationsShip:nil];
}

+ (NSMutableDictionary *)getDictionaryFromEntity:(NSManagedObject *)theObject
                        doNotFollowRelationsShip:(NSRelationshipDescription *)theDoNotFollowRelationShip
{
  NSMutableDictionary *definitionDictionary = [NSMutableDictionary dictionary];
  NSArray *valuesKeys = [[self entityDefinitionClassForObject:theObject] valuesKeys];
  NSDictionary *relationshipsByName = [[theObject entity] relationshipsByName];

  for (NSString *key in valuesKeys) {
    if ([[relationshipsByName allKeys] containsObject:key] &&
      [[relationshipsByName objectForKey:key] isEqual:theDoNotFollowRelationShip] == NO) {
      NSRelationshipDescription *description = [[[theObject entity] relationshipsByName] objectForKey:key];

      NSRelationshipDescription *doNotFollowRelationShip = [relationshipsByName objectForKey:key];

      if (![description isToMany]) {
        NSManagedObject *relationshipObject = [theObject valueForKey:key];
        [definitionDictionary setObject:[self getDictionaryFromEntity:relationshipObject
                                             doNotFollowRelationsShip:doNotFollowRelationShip]
                                 forKey:key];
        continue;
      }

      NSSet *relationshipObjects = [theObject valueForKey:key];
      NSMutableArray *relationshipArray = [[NSMutableArray alloc] init];
      for (NSManagedObject *relationshipObject in relationshipObjects) {
        [relationshipArray addObject:[self getDictionaryFromEntity:relationshipObject
                                          doNotFollowRelationsShip:doNotFollowRelationShip]];
      }
      [definitionDictionary setObject:relationshipArray forKey:key];
    }
    else {
      id entityValue = [theObject valueForKey:key];
      [definitionDictionary setValue:entityValue forKey:key];
    }
  }
  return definitionDictionary;
}

- (void)loadValuesFromDictionary:(NSDictionary *)theValues
{
  [[self dictionary] addEntriesFromDictionary:theValues];
}


- (NSString *)stringValueWithName:(NSString *)theValueName
{
  NSAssert(theValueName, nil);

  NSString *value = [[self dictionary] valueForKey:theValueName];
  if (value) {
    NSAssert([value isKindOfClass:[NSString class]] == YES, nil);
  }

  return value;
}

- (void)setStringValueWithName:(NSString *)theValueName
                         value:(NSString *)theValue
{
  NSAssert(theValueName, nil);

  if (theValue) {
    NSAssert([theValue isKindOfClass:[NSString class]], nil);
  }

  [[self dictionary] setValue:theValue forKey:theValueName];
}

- (NSDate *)dateValueWithName:(NSString *)theName
{
  id value = [[self dictionary] valueForKey:theName];
  if (!value) {
    return nil;
  }

  NSDate *dateValue = nil;

  if ([value isKindOfClass:[NSString class]]) {
    NSString *stringValue = [self stringValueWithName:theName];
    dateValue = [NSDate dateFromWebServiceDateString:stringValue];
  }
  else if ([value isKindOfClass:[NSDate class]]) {
    dateValue = value;
  }
  UNHANDLED_IF

  return dateValue;
}

- (void)setDateValueWithName:(NSString *)theName value:(NSDate *)theValue
{
  NSAssert(theName, nil);

  if (theValue) {
    NSAssert([theValue isKindOfClass:[NSDate class]], nil);
  }

  [[self dictionary] setValue:theValue forKey:theName];
}

- (NSNumber *)integerNumberValueWithName:(NSString *)theName
{
  id value = [[self dictionary] valueForKey:theName];
  if (!value) {
    return nil;
  }

  NSNumber *numberValue = nil;

  if ([value isKindOfClass:[NSNumber class]]) {
    numberValue = value;
  }
  else if ([value isKindOfClass:[NSString class]]) {
    NSString *stringValue = value;
    numberValue = [NSNumber numberWithInteger:[stringValue integerValue]];
  }
  UNHANDLED_IF

  return numberValue;
}

- (void)setNumberValueWithName:(NSString *)theName integerNumber:(NSNumber *)theValue
{
  NSAssert(theName, nil);
  if (theValue) {
    NSAssert([theValue isKindOfClass:[NSNumber class]], nil);
  }

  [[self dictionary] setValue:theValue forKey:theName];
}

- (NSArray *)definitionsArrayValueWithName:(NSString *)theName
{
  Class entityDefinitionClass = [DSEntityDefinition entityDefinitionClassForRelationshipKey:theName];

  NSArray *rawDefinitions = [[self dictionary] objectForKey:theName];
  NSMutableArray *definitions = [NSMutableArray arrayWithCapacity:[rawDefinitions count]];

  for (NSDictionary *rawDefinition in rawDefinitions) {
    DSEntityDefinition *definition = [entityDefinitionClass definitionWithDictionary:rawDefinition];
    [definitions addObject:definition];
  }

  return definitions;
}

- (void)setDefinitionsArraysWithName:(NSString *)theName
                         definitions:(NSArray *)theDefinitions
{
  NSMutableArray *rawDefinitions
    = [NSMutableArray arrayWithCapacity:[theDefinitions count]];

  for (DSEntityDefinition *definition in theDefinitions) {
    NSDictionary *rawDefinition = [definition dictionary];
    [rawDefinitions addObject:rawDefinition];
  }
  [[self dictionary] setObject:rawDefinitions forKey:theName];
}

- (NSArray *)rawDefinitionsArrayValueWithName:(NSString *)theName
{
  return [[self dictionary] objectForKey:theName];
}


+ (void)enumerateDefinitionsFromArray:(NSArray *)theDefinitions
                            withBlock:(void (^)(id,
                                                NSUInteger,
                                                BOOL *))theBlock
{
  [theDefinitions enumerateObjectsUsingBlock:
                    ^void(NSDictionary *def, NSUInteger idx, BOOL *stop)
                    {
                      DSEntityDefinition *definition = [[self alloc] initWithDictionary:def];
                      theBlock(definition, idx, stop);
                    }];
}

- (void)forwardInvocation:(NSInvocation *)anInvocation
{
  NSString *m = NSStringFromSelector([anInvocation selector]);

  NSInteger lastParamIndex = 2;
  [anInvocation setArgument:&m atIndex:lastParamIndex + 1];

  [anInvocation setSelector:@selector(handleSetterWithValue:setterName:)];
  [anInvocation invokeWithTarget:self];
}

/** \param theSetter looks like: setParamName */
- (NSString *)valueNameFromSetterName:(NSString *)theSetter
{
  NSString *withoutSet
    = [theSetter stringByReplacingCharactersInRange:NSMakeRange(0, 3)
                                         withString:@""];
  NSString *lowerFirstChar =
    [withoutSet stringByReplacingCharactersInRange:NSMakeRange(0, 1)
                                        withString:[[withoutSet substringToIndex:1]
                                                                lowercaseString]];
  NSString *removedDoubleDots = [lowerFirstChar stringByReplacingOccurrencesOfString:@":"
                                                                          withString:@""];
  return removedDoubleDots;
}

- (void)handleSetterWithValue:(id)value setterName:(NSString *)theSetterName
{
  NSString *valueName = [self valueNameFromSetterName:theSetterName];

  if ([value isKindOfClass:[NSString class]]) {
    [self setStringValueWithName:valueName value:value];
  }
  else if ([value isKindOfClass:[NSDate class]]) {
    [self setDateValueWithName:valueName value:value];
  }
  else if ([value isKindOfClass:[NSNumber class]]) {
    [self setNumberValueWithName:valueName integerNumber:value];
  }
  else if ([value isKindOfClass:[NSArray class]]) {
    [self setDefinitionsArraysWithName:valueName
                           definitions:value];
  }
  UNHANDLED_IF;
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)selector
{
  NSMethodSignature *signature = [super methodSignatureForSelector:selector];

  if (!signature) {
    signature
      = [self methodSignatureForSelector:@selector(handleSetterWithValue:setterName:)];
  }

  return signature;
}

- (NSString *)description
{
  NSArray *keys = [self valuesKeys];
  NSMutableString *description
    = [NSMutableString stringWithFormat:@"%@: {\n", NSStringFromClass([self class])];

  for (NSString *key in keys) {
    id value = [self valueForKey:key];
    [description appendFormat:@"%@: %@\n", key, value];
  }

  [description appendString:@"}"];

  return description;
}

+ (NSString *)classPrefix
{
  return [[DSWebServiceConfiguration sharedInstance] classPrefix];
}

@end

@implementation DSEntityDefinition (Abstract)

- (NSArray *)valuesKeys
{
  ASSERT_ABSTRACT_METHOD;
  return nil;
}

+ (NSArray *)valuesKeys
{
  ASSERT_ABSTRACT_METHOD;
  return nil;
}

@end
