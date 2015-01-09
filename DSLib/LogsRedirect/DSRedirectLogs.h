//
//  DSRedirectLogs.h
//  DSLib
//
//  Created by Alexander Belyavskiy on 5/14/14.
//  Copyright (c) 2014 DS ltd. All rights reserved.
//

@import Foundation;

typedef void (^DSRedirectLogsHandler) (NSString *format, va_list args_list);

@interface DSRedirectLogs : NSObject
@property (nonatomic, copy) void (^customLogger)(NSString *format, va_list args_list);
+ (instancetype)sharedInstance;

- (void)log:(NSString *)format args:(va_list)args;
@end

void DSRedirectLog(NSString *format, ...);
