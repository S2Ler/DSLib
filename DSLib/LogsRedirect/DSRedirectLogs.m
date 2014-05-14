//
//  DSRedirectLogs.m
//  DSLib
//
//  Created by Alexander Belyavskiy on 5/14/14.
//  Copyright (c) 2014 DS ltd. All rights reserved.
//

#import "DSRedirectLogs.h"
#import "DSMacros.h"

@implementation DSRedirectLogs
+ (instancetype)sharedInstance
{
  DEFINE_SHARED_INSTANCE_USING_BLOCK(^{
    return [[self alloc] init];
  });
}

- (void)log:(NSString *)format args:(va_list)args
{
  if ([self customLogger]) {
    [self customLogger](format, args);
  }
  else {
    NSLogv(format, args);
  }
}
@end

void DSRedirectLog(NSString *format, ...)
{
  va_list list;
  va_start(list, format);
  
  [[DSRedirectLogs sharedInstance] log:format args:list];
}
