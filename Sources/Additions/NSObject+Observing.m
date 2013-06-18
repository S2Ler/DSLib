//
//  NSObject+Observing.m
//  FlipDrive
//
//  Created by Alexander Belyavskiy on 12/30/11.
//  Copyright (c) 2011 FlipDrive.com. All rights reserved.
//

#import "NSObject+Observing.h"

@implementation NSObject (Observing)
- (void)addObserver:(NSObject *)theObserver
        forKeyPaths:(NSString *)theKeyPath,... {
  if (!theKeyPath) return;
  
  [self addObserver:theObserver 
         forKeyPath:theKeyPath
            options:(NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld)
            context:(__bridge void *)(theObserver)];
  
  NSString *nextKeyPath;
  va_list argumentList;
  va_start(argumentList, theKeyPath);
  
  while ((nextKeyPath = va_arg(argumentList, NSString *))) {
    [self addObserver:theObserver 
           forKeyPath:nextKeyPath
              options:(NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld)
              context:(__bridge void *)(theObserver)];
  }
  
  va_end(argumentList);  
}

- (void)removeObserver:(NSObject *)theObserver
              keyPaths:(NSString *)theKeyPath,...
{
  if (!theKeyPath) return;
  
  @try {
    [self removeObserver:theObserver forKeyPath:theKeyPath];
  }
  @catch (NSException *exception) {
    //
  }
  
  NSString *nextKeyPath;
  va_list argumentList;
  va_start(argumentList, theKeyPath);
  
  while ((nextKeyPath = va_arg(argumentList, NSString *))) {
    @try {
      [self removeObserver:theObserver forKeyPath:nextKeyPath];
    }
    @catch (NSException *exception) {
      //
    }    
  }
  va_end(argumentList);
}
@end
