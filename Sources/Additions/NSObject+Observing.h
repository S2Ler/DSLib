//
//  NSObject+Observing.h
//  FlipDrive
//
//  Created by Alexander Belyavskiy on 12/30/11.
//  Copyright (c) 2011 FlipDrive.com. All rights reserved.
//



@interface NSObject (Observing)
- (void)addObserver:(NSObject *)theObserver
        forKeyPaths:(NSString *)theKeyPath,...;
- (void)removeObserver:(NSObject *)theObserver
              keyPaths:(NSString *)theKeyPath,...;
@end
