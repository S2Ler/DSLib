//
//  NSError+DSMessage.h
//  DSLib
//
//  Created by Alexander Belyavskiy on 6/27/14.
//  Copyright (c) 2014 DS ltd. All rights reserved.
//

@import Foundation;

@class DSMessage;

@interface NSError (DSMessage)
- (NSString *)title;
+ (instancetype)errorWithTitle:(NSString *)title description:(NSString *)description;
+ (instancetype)errorFromMessage:(DSMessage *)message;
                                  
@end
