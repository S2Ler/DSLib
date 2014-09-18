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
@property (nonatomic, strong) NSMutableDictionary *dateFormatters;
@end

@implementation DSDynamicPropertyObject
- (id)initWithContainer:(id)container
{
  self = [super init];
  if (self) {
    _container = container;
    _dateFormatters = [[NSMutableDictionary alloc] initWithCapacity:2];
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
  else if ([type hasPrefix:@"d"]) {
    [anInvocation setSelector:@selector(handleDoubleWithName:)];
  }
  else if ([type hasPrefix:@"q"]) {
    [anInvocation setSelector:@selector(handleLongLongWithName:)];
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

- (NSNumber *)numberForGetterName:(NSString *)getterName
{
  id numberObject = [[self container] valueForKeyPath:[self keypathForGetter:getterName]];
  NSNumber *number = nil;
  
  if ([numberObject isKindOfClass:[NSNumber class]]) {
    number = numberObject;
  }
  else if ([numberObject isKindOfClass:[NSString class]]) {
    number = [[[self class] numberFormatter] numberFromString:numberObject];
  }
  return number;
}

- (NSUInteger)handleUnsignedIntegerWithName:(NSString *)getterName
{
  NSNumber *number = [self numberForGetterName:getterName];
  return [number unsignedIntegerValue];
}

- (unsigned long long)handleUnsignedLongLongWithName:(NSString *)getterName
{
  NSNumber *number = [self numberForGetterName:getterName];
  return [number unsignedLongLongValue];
}

- (double)handleDoubleWithName:(NSString *)getterName
{
  NSNumber *number = [self numberForGetterName:getterName];
  return [number doubleValue];
}

- (long long)handleLongLongWithName:(NSString *)getterName
{
  NSNumber *number = [self numberForGetterName:getterName];
  return [number longLongValue];
}

/** \param theSetter looks like: setParamName */
- (id)handleObjectGetterWithName:(NSString *)getterName
{
  NSString *value = [[self container] valueForKeyPath:[self keypathForGetter:getterName]];
  return value;
}

- (id)handleStringToNumberGetterWithName:(NSString *)getterName
{
  NSNumber *number = [self numberForGetterName:getterName];
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
    NSString *customDateFormat = [self dateFormatForGetter:getterName];
    
    if (customDateFormat) {
      NSDateFormatter *dateFormatter = [[self dateFormatters] objectForKey:customDateFormat];
      if (!dateFormatter) {
        dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:customDateFormat];
        [[self dateFormatters] setObject:dateFormatter forKey:customDateFormat];
      }
      date = [dateFormatter dateFromString:dateObject];
    }
    else {
      date = [NSDate dateWithTimeIntervalSince1970:[dateObject doubleValue]];
    }
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

- (NSString *)dateFormatForGetter:(NSString *)getter
{
  return nil;
}

- (NSString *)keypathForGetter:(NSString *)getter
{
  return getter;
}

- (id)containerValueForKeyPath:(NSString *)keyPath
{
  return [[self container] valueForKeyPath:keyPath];
}
@end
