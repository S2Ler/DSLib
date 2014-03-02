//
//  DSAskForTextController.h
//  DSLib
//
//  Created by Alex on 12/11/2013.
//  Copyright (c) 2013 DS ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^DSAskForTextControllerCompletion) (BOOL success, NSString *text);

typedef NS_OPTIONS(NSUInteger, DSAskForTextControllerOptions) {
  DSAskForTextControllerOptionNone = 0,
  DSAskForTextControllerOptionSecure = 1 << 0,
  DSAskForTextControllerOptionTrimWhiteSpace = 1 << 1,
  DSAskForTextControllerOptionPlaceholderIsValidText = 1 << 2
};

@interface DSAskForTextController : NSObject
+ (instancetype)shareInstance;

- (void)askForTextWithTitle:(NSString *)title
                   isSecure:(BOOL)secure
                placeholder:(NSString *)placeholder
                initialText:(NSString *)initialText
             withCompletion:(DSAskForTextControllerCompletion)completion;

- (void)askForTextWithTitle:(NSString *)title
                placeholder:(NSString *)placeholder
                initialText:(NSString *)initialText
                    options:(DSAskForTextControllerOptions)options
             withCompletion:(DSAskForTextControllerCompletion)completion;


@end
