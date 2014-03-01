//
//  DSMessageTransformer.m
//  DSLib
//
//  Created by Alexander Belyavskiy on 3/1/14.
//  Copyright (c) 2014 DS ltd. All rights reserved.
//

#pragma mark - include
#import "DSMessageTransformer.h"
#import "DSMessage.h"

@implementation DSMessageTransformer

+ (void)initialize
{
	DSMessageTransformer *transformer = [[DSMessageTransformer alloc] init];
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

- (id)transformedValue:(id)value
{
  DSMessage *message = value;
  return [NSKeyedArchiver archivedDataWithRootObject:message];
}

- (id)reverseTransformedValue:(id)value
{
  return [NSKeyedUnarchiver unarchiveObjectWithData:value];
}

@end
