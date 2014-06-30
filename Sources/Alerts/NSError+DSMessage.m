//
//  NSError+DSMessage.m
//  DSLib
//
//  Created by Alexander Belyavskiy on 6/27/14.
//  Copyright (c) 2014 DS ltd. All rights reserved.
//

#pragma mark - include
#import "NSError+DSMessage.h"

#define ERROR_TITLE_KEY @"DSMessage_title"

@implementation NSError (DSMessage)

- (NSString *)title
{
  return [[self userInfo] objectForKey:ERROR_TITLE_KEY];
}

+ (instancetype)errorWithTitle:(NSString *)title description:(NSString *)description
{
  NSError *error = [NSError errorWithDomain:NSCocoaErrorDomain
                                       code:0
                                   userInfo:@{NSLocalizedDescriptionKey: description,
                                              ERROR_TITLE_KEY: title}];
  return error;
}
@end
