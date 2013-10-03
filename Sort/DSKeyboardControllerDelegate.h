//
//  DSKeyboardControllerDelegate.h
//  DSLib
//
//  Created by Alexander Belyavskiy on 9/24/13.
//  Copyright (c) 2013 DS ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@class DSKeyboardController;

@protocol DSKeyboardControllerDelegate<NSObject>
@optional

- (void)    keyboardController:(DSKeyboardController *)keyboardController
keyboardWillShowWithFrameBegin:(CGRect)frameBegin
                      frameEnd:(CGRect)frameEnd
             animationDuration:(double)animationDuration
                animationCurve:(UIViewAnimationCurve)animationCurve;

- (void)   keyboardController:(DSKeyboardController *)keyboardController
keyboardDidShowWithFrameBegin:(CGRect)frameBegin
                     frameEnd:(CGRect)frameEnd;

- (void)    keyboardController:(DSKeyboardController *)keyboardController
keyboardWillHideWithFrameBegin:(CGRect)frameBegin
                      frameEnd:(CGRect)frameEnd
             animationDuration:(double)animationDuration
                animationCurve:(UIViewAnimationCurve)animationCurve;

- (void)   keyboardController:(DSKeyboardController *)keyboardController
keyboardDidHideWithFrameBegin:(CGRect)frameBegin
                     frameEnd:(CGRect)frameEnd;

- (void)keyboardController:(DSKeyboardController *)keyboardController
       willChangeFrameFrom:(CGRect)frameBeing
                        to:(CGRect)frameEnd;

- (void)keyboardController:(DSKeyboardController *)keyboardController
        didChangeFrameFrom:(CGRect)frameBeing
                        to:(CGRect)frameEnd;
@end
