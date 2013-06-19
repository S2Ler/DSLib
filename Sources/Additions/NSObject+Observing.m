//
//  NSObject+Observing.m
//  FlipDrive
//
//  Created by Alexander Belyavskiy on 12/30/11.
//  Copyright (c) 2011 FlipDrive.com. All rights reserved.
//

#pragma mark - include
#import "NSObject+Observing.h"
#import <objc/runtime.h>

@implementation NSObject (Observing)
static char BLOCK_OBSERVING_CONTEXT;
static const char observerBlocksDictionaryKey;

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

- (NSMutableDictionary *)observerBlocksDictionary
{
    NSMutableDictionary *observerBlocksDictionary = objc_getAssociatedObject(self, &observerBlocksDictionaryKey);
    if (!observerBlocksDictionary) {
        observerBlocksDictionary = [[NSMutableDictionary alloc] init];
        objc_setAssociatedObject(self,
                                 &observerBlocksDictionaryKey,
                                 observerBlocksDictionary,
                                 OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return observerBlocksDictionary;
}

- (void)addObserverForKeyPath:(NSString *)keypath
                        block:(NSObjectObserverBlock)block
{
    NSAssert(block, @"Cannot run without block. Doesn't make sense", nil);
    NSAssert(keypath, @"Keypath cannot be nil", nil);

    if (!block) return;

    [[self observerBlocksDictionary] setObject:block
                                        forKey:keypath];
    [self addObserver:self
           forKeyPath:keypath
              options:NSKeyValueObservingOptionNew
              context:&BLOCK_OBSERVING_CONTEXT];
}

- (void)removeObserverForKeyPath:(NSString *)keyPath
{
    [[self observerBlocksDictionary] removeObjectForKey:keyPath];
    [self removeObserver:self
              forKeyPath:keyPath
                 context:&BLOCK_OBSERVING_CONTEXT];
}

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context
{
    if (context == &BLOCK_OBSERVING_CONTEXT) {
        NSObjectObserverBlock observerBlock = [[self observerBlocksDictionary] objectForKey:keyPath];
        if (observerBlock) {
            observerBlock(self, keyPath);
        }
    }
}


@end
