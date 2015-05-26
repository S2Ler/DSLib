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
- (nullable NSString *)title;
+ (nonnull instancetype)errorWithTitle:(nonnull NSString *)title
                           description:(nonnull NSString *)description;
+ (nonnull instancetype)errorWithTitle:(nonnull NSString *)title
                           description:(nonnull NSString *)description
                                domain:(nonnull NSString *)domain
                                  code:(nonnull NSString *)code;
+ (nonnull instancetype)errorFromMessage:(nonnull DSMessage *)message;
- (BOOL)isErrorFromMessage;
- (nullable NSString *)extractMessageCode;
                                  
@end
