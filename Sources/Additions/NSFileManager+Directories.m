//
//  NSFileManager+Directories.m
//  GainFx Trade
//
//  Created by Alexander Belyavskiy on 7/5/11.
//  Copyright 2011 iTechArt. All rights reserved.
//

#import "NSFileManager+Directories.h"


@implementation NSFileManager (NSFileManager_Directories)
+ (NSString *)userDirectoryOfType:(NSSearchPathDirectory)theType {
  NSArray *dirs = 
  NSSearchPathForDirectoriesInDomains(theType, NSUserDomainMask, YES);
  if ([dirs count] > 0) {
    return [dirs objectAtIndex:0];
  } else {
    return nil;
  }
}
@end
