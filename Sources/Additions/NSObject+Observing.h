//
//  NSObject+Observing.h
//  FlipDrive
//
//  Created by Alexander Belyavskiy on 12/30/11.
//  Copyright (c) 2011 FlipDrive.com. All rights reserved.
//

typedef void (^NSObjectObserverBlock)(id object, NSString *keyPath);


@interface NSObject (Observing)
- (void)addObserver:(NSObject *)theObserver
        forKeyPaths:(NSString *)theKeyPath,...;
- (void)removeObserver:(NSObject *)theObserver
              keyPaths:(NSString *)theKeyPath,...;

/** Not thread save */
- (void)addObserverForKeyPath:(NSString *)keypath block:(NSObjectObserverBlock)block;
- (void)removeObserverForKeyPath:(NSString *)keyPath;
@end
