//
//  DSAskForTextController.h
//  DSLib
//
//  Created by Alex on 12/11/2013.
//  Copyright (c) 2013 DS ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^DSAskForTextControllerCompletion) (BOOL success, NSString *text);

@interface DSAskForTextController : NSObject
+ (instancetype)shareInstance;

- (void)askForTextWithTitle:(NSString *)title
                   isSecure:(BOOL)secure
                placeholder:(NSString *)placeholder
                initialText:(NSString *)initialText
             withCompletion:(DSAskForTextControllerCompletion)completion;
@end
