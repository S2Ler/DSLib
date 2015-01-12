//
//  NSBundle+DSBundle.m
//  DSLib
//
//  Created by Alex on 06/11/2013.
//  Copyright (c) 2013 DS ltd. All rights reserved.
//

#import "NSBundle+DSBundle.h"

@implementation NSBundle (DSBundle)
+ (NSBundle*)DSLibBundle {
  static dispatch_once_t onceToken;
  static NSBundle *bundle = nil;
  dispatch_once(&onceToken, ^{
    bundle = [NSBundle bundleWithIdentifier:@"com.diejmon.DSLibFramework"];
  });
  return bundle;
}
@end
