//
//  DSMessage+Parse.m
//  DSLib
//
//  Created by Alex on 05/11/2013.
//  Copyright (c) 2013 DS ltd. All rights reserved.
//

#pragma mark - include
#import "DSMessage+Parse.h"
#import "NSError+Parse.h"


@implementation DSMessage (Parse)
+ (instancetype)messageWithParseError:(NSError *)parseError
{
  return [DSMessage messageWithError:[parseError correctedParseError]];
}
@end
