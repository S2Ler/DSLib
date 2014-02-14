//
//  NSNumber+DSAdditions.m
//  DSLib
//
//  Created by Alexander Belyavskiy on 2/10/14.
//  Copyright (c) 2014 DS ltd. All rights reserved.
//

#import "NSNumber+DSAdditions.h"

@implementation NSNumber (DSAdditions)
- (DSFileSize)fileSizeValue
{
  return [self longLongValue];
}
@end
