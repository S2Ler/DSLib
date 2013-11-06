//
//  DSMessage+Parse.h
//  DSLib
//
//  Created by Alex on 05/11/2013.
//  Copyright (c) 2013 DS ltd. All rights reserved.
//

#import "DSMessage.h"


@interface DSMessage (Parse)
+ (instancetype)messageWithParseError:(NSError *)parseError;
@end
