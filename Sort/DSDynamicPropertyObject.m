//
//  DSDynamicPropertyObject.m
//  DSLib
//
//  Created by Alexander Belyavskiy on 2/5/14.
//  Copyright (c) 2014 DS ltd. All rights reserved.
//

#pragma mark - include
#import "DSDynamicPropertyObject.h"
#import "MARTNSObject.h"
#import "RTProperty.h"
#import "DSMacros.h"

@interface DSDynamicPropertyObject ()

@end

@implementation DSDynamicPropertyObject
- (id)initWithContainer:(id)container
{
  self = [super init];
  if (self) {
    _container = container;
  }
  return self;
}

#pragma mark - dynamic properties
- (void)forwardInvocation:(NSInvocation *)anInvocation
{
  NSString *getterName = NSStringFromSelector([anInvocation selector]);
  
  NSInteger lastParamIndex = 1;
  [anInvocation setArgument:&getterName atIndex:lastParamIndex + 1];
  
  NSString *type = [self typeForPropertyWithName:getterName];
  if ([type hasPrefix:@"@\"NSNumber\""]) {
    [anInvocation setSelector:@selector(handleStringToNumberGetterWithName:)];
  }
  else if ([type hasPrefix:@"@\"NSDate\""]) {
    [anInvocation setSelector:@selector(handleStringToDateGetterWithName:)];
  }
  else if ([type hasPrefix:@"@"]) {
    [anInvocation setSelector:@selector(handleObjectGetterWithName:)];
  }
  else if ([type hasPrefix:@"I"]) {
    [anInvocation setSelector:@selector(handleUnsignedIntegerWithName:)];
  }
  else if ([type hasPrefix:@"Q"]) {
    [anInvocation setSelector:@selector(handleUnsignedLongLongWithName:)];
  }
  UNHANDLED_IF;
  
  [anInvocation invokeWithTarget:self];
}

- (NSString *)typeForPropertyWithName:(NSString *)propertyName
{
  RTProperty *property = [[self class] rt_propertyForName:propertyName];
  NSAssert([property isReadOnly], @"Custom accessors to response dictionary should be readonly properties");
  if (property) {
    NSString *typeEncoding = [property typeEncoding];
    return typeEncoding;
  }
  return nil;
}

+ (NSNumberFormatter *)numberFormatter
{
  DEFINE_SHARED_INSTANCE_USING_BLOCK(^{
    return [[NSNumberFormatter alloc] init];
  });
}

- (NSNumber *)numberForPropertyName:(NSString *)propertyName
{
  id numberObject = [[self container] valueForKeyPath:[self keypathForGetter:propertyName]];
  NSNumber *number = nil;
  
  if ([numberObject isKindOfClass:[NSNumber class]]) {
    number = numberObject;
  }
  else if ([numberObject isKindOfClass:[NSString class]]) {
    number = [[[self class] numberFormatter] numberFromString:numberObject];
  }
  return number;
}

- (NSUInteger)handleUnsignedIntegerWithName:(NSString *)propertyName
{
  NSNumber *number = [self numberForPropertyName:propertyName];
  return [number unsignedIntegerValue];
}

- (unsigned long long)handleUnsignedLongLongWithName:(NSString *)propertyName
{
  NSNumber *number = [self numberForPropertyName:propertyName];
  return [number unsignedLongLongValue];
}

/** \param theSetter looks like: setParamName */
- (id)handleObjectGetterWithName:(NSString *)getterName
{
  NSString *value = [[self container] valueForKeyPath:[self keypathForGetter:getterName]];
  return value;
}

- (id)handleStringToNumberGetterWithName:(NSString *)getterName
{
  NSNumber *number = [self numberForPropertyName:getterName];
  return number;
}

- (id)handleStringToDateGetterWithName:(NSString *)getterName
{
  id dateObject = [[self container] valueForKeyPath:[self keypathForGetter:getterName]];
  NSDate *date = nil;
  
  if ([dateObject isKindOfClass:[NSDate class]]) {
    date = dateObject;
  }
  else if ([dateObject isKindOfClass:[NSString class]]) {
    date = [NSDate dateWithTimeIntervalSince1970:[dateObject doubleValue]];
  }

  return date;
}


- (NSMethodSignature *)methodSignatureForSelector:(SEL)selector
{
  NSMethodSignature *signature = [super methodSignatureForSelector:selector];
  
  if (!signature) {
    NSString *typeEncoding = [self typeForPropertyWithName:NSStringFromSelector(selector)];
    if (typeEncoding) {
      signature = [NSMethodSignature signatureWithObjCTypes:[[NSString stringWithFormat:@"%@@:@", typeEncoding]cStringUsingEncoding:NSUTF8StringEncoding]];
    }
  }
  
  return signature;
}

- (NSDictionary *)allValues
{
  NSMutableDictionary *values = [NSMutableDictionary dictionary];
  NSArray *properties = [[self class] rt_properties];
  for (RTProperty *property in properties) {
    SEL selector = NSSelectorFromString([property name]);
    NSInvocation *invocation
    = [NSInvocation invocationWithMethodSignature:[self methodSignatureForSelector:selector]];
    [invocation setTarget:self];
    [invocation setSelector:selector];
    [self forwardInvocation:invocation];
    __autoreleasing id value;
    [invocation getReturnValue:&value];
    if (value) {
      values[[property name]] = value;
    }
  }
  
  return values;
}
@end
