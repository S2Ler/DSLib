//
//  DSMessageInterceptor.m
//  DSLib
//
//  Created by Alexander Belyavskiy on 3/30/14.
//  Copyright (c) 2014 DS ltd. All rights reserved.
//

#import "DSMessageInterceptor.h"


@interface DSMessageInterceptor ()
@property (nonatomic, copy) ds_completion_handler handler;

@end

@implementation DSMessageInterceptor
- (void)setCode:(NSString *)code
{
  _code = code;
  _codes = nil;
}

- (void)setCodes:(NSArray *)codes
{
  _codes = codes;
  _code = nil;
}
@end
