//
//  NSError+DSMessage.m
//  DSLib
//
//  Created by Alexander Belyavskiy on 6/27/14.
//  Copyright (c) 2014 DS ltd. All rights reserved.
//

#pragma mark - include
#import "NSError+DSMessage.h"
#import "DSMessage.h"

#define ERROR_TITLE_KEY @"DSMessage_title"
#define ERROR_CODE_KEY @"DSMessage_code"
NSInteger kUnknownCode = NSIntegerMin;

@implementation NSError (DSMessage)

- (NSString *)title
{
  return [[self userInfo] objectForKey:ERROR_TITLE_KEY];
}

+ (instancetype)errorWithTitle:(NSString *)title description:(NSString *)description
{
  return [self errorWithTitle:title
                  description:description
                       domain:NSCocoaErrorDomain
                         code:@"0"];
}

+ (instancetype)errorWithTitle:(NSString *)title
                   description:(NSString *)description
                        domain:(NSString *)domain
                          code:(NSString *)code
{
  NSError *error = [NSError errorWithDomain:domain
                                       code:kUnknownCode
                                   userInfo:@{NSLocalizedDescriptionKey: description,
                                              ERROR_TITLE_KEY: title,
                                              ERROR_CODE_KEY: code}];
  return error;
}

+ (instancetype)errorFromMessage:(DSMessage *)message
{
  return [self errorWithTitle:[message localizedTitle]
                  description:[message localizedBody]
                       domain:message.domain
                         code:message.code];
}

- (BOOL)isErrorFromMessage
{
  return self.code == kUnknownCode && [self.userInfo objectForKey:ERROR_CODE_KEY] != nil;
}

- (NSString *)extractMessageCode
{
  return [self.userInfo objectForKey:ERROR_CODE_KEY];
}
@end
