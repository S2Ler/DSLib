//
//  UIDevice+Addittions.m
//  FlipDrive
//
//  Created by Belyavskiy Alexander on 5/14/11.
//  Copyright 2011 FilpDrive.com. All rights reserved.
//

#import "UIDevice+Addittions.h"


@implementation UIDevice (Addittions)
+ (NSString *)deviceIOSVersion {
  static NSString *iosVersion = nil;
  
  if (!iosVersion) {
    iosVersion = [[[UIDevice currentDevice] systemVersion] retain];
  }
  
  return iosVersion;
}

+ (BOOL)isIOSVersionGreaterOrEqualTo:(NSString *)theIOSVersionToCompare {
  return ([[self deviceIOSVersion]
           compare:theIOSVersionToCompare
           options:NSNumericSearch] != NSOrderedAscending);
}

@end
