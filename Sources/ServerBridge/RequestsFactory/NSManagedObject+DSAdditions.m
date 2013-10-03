
#import "NSManagedObject+DSAdditions.h"
#import "DSEntityDefinition.h"
#import "DSWebServiceConfiguration.h"


//@implementation NSManagedObject (DSAdditions)
//+ (id)objectWithID:(NSNumber *)theID
//{
//  return [self MR_findFirstByAttribute:@"recID" withValue:theID];
//}
//
//- (BOOL)hasBeenDeletedFromTheContext
//{
//  return [self managedObjectContext] == nil;
//}
//
//- (void)importRelationshipDefinition:(DSEntityDefinition *)theDefinition
//                              forKey:(NSString *)theKey
//{
//  NSSet *currentValues = [self valueForKey:theKey];
//  NSNumber *uuid = [theDefinition recID];
//
//  id valueToUpdate = nil;
//
//  for (id value in currentValues) {
//    NSAssert([value respondsToSelector:@selector(recID)], @"entity should have recID", nil);
//    NSNumber *valueID = [value recID];
//    if ([valueID isEqualToNumber:uuid]) {
//      valueToUpdate = value;
//      break;
//    }
//  }
//
//  if (!valueToUpdate) {
//    valueToUpdate = [[[self class] entityClassForRelationshipKey:theKey] MR_createEntity];
//    NSMutableSet *currentValuesSet = [self mutableSetValueForKey:theKey];
//    if (!currentValuesSet) {
//      currentValuesSet = [[NSMutableSet alloc] init];
//    }
//    [currentValuesSet addObject:valueToUpdate];
//  }
//
//  [valueToUpdate updateDataFromDefinition:theDefinition];
//}
//
//- (void)updateDataFromDefinition:(DSEntityDefinition *)theDefinition
//{
//  NSArray *keypaths = [theDefinition valuesKeys];
//
//  NSArray *relationshipKeys = [[[self entity] relationshipsByName] allKeys];
//
//  for (NSString *keypath in keypaths) {
//    id value = [theDefinition valueForKeyPath:keypath];
//    if ([relationshipKeys containsObject:keypath]) {
//      for (DSEntityDefinition *definition in value) {
//        [self importRelationshipDefinition:definition forKey:keypath];
//      }
//    }
//    else {
//      [self setValue:value forKey:keypath];
//    }
//  }
//}
//
//+ (Class)entityClassForEntityName:(NSString *)entityName
//{
//  NSString
//    *entityDefinitionClassName = [NSString stringWithFormat:@"%@%@", [self classPrefix], entityName];
//  Class entityDefinitionClass = NSClassFromString(entityDefinitionClassName);
//  return entityDefinitionClass;
//}
//
//+ (NSString *)classPrefix
//{
//  return [[DSWebServiceConfiguration sharedInstance] classPrefix];
//}
//
//+ (Class)entityClassForRelationshipKey:(NSString *)theRelationshipKey
//{
//  NSString *entityName
//    = [[theRelationshipKey stringByReplacingOccurrencesOfString:@"_collection"
//                                                     withString:@""] capitalizedString];
//  return [self entityClassForEntityName:entityName];
//}
//
//@end
