//
//  DSMessageTransformer.m
//  DSLib
//
//  Created by Alexander Belyavskiy on 3/1/14.
//  Copyright (c) 2014 DS ltd. All rights reserved.
//

#pragma mark - include
#import "DSCodingTransformer.h"
#import "DSMessage.h"

@implementation DSCodingTransformer

+ (void)initialize
{
	DSCodingTransformer *transformer = [[DSCodingTransformer alloc] init];
  [NSValueTransformer setValueTransformer:transformer forName:NSStringFromClass([self class])];
}

+ (BOOL)allowsReverseTransformation
{
  return YES;
}

+ (Class)transformedValueClass
{
  return [NSData class];
}

- (id)transformedValue:(id<NSCoding>)value
{
  return [NSKeyedArchiver archivedDataWithRootObject:value];
}

- (id)reverseTransformedValue:(NSData *)value
{
  return [NSKeyedUnarchiver unarchiveObjectWithData:value];
}

@end
