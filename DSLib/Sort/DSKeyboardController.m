//
//  DSKeyboardController.m
//  DSLib
//
//  Created by Alexander Belyavskiy on 9/24/13.
//  Copyright (c) 2013 DS ltd. All rights reserved.
//

#import "DSKeyboardController.h"

@implementation DSKeyboardController

- (void)dealloc
{
  [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (id)init
{
    self = [super init];
    if (self) {
        [self setupNotificationCenter];
    }
    return self;
}

- (CGRect)convertRect:(CGRect)rect toView:(UIView *)view
{
    return [[[UIApplication sharedApplication] keyWindow] convertRect:rect
                                                               toView:view];
}

#pragma mark - Managging  Notifications
- (void)setupNotificationCenter
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardDidShow:)
                                                 name:UIKeyboardDidShowNotification
                                               object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardDidHide:)
                                                 name:UIKeyboardDidHideNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillChangeFrame:)
                                                 name:UIKeyboardWillChangeFrameNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardDidChangeFrame:)
                                                 name:UIKeyboardDidChangeFrameNotification
                                               object:nil];
}

- (void)keyboardWillShow:(NSNotification *)notification
{
#if DSKeyboardControllerDebug
  NSLog(@"keyboardWillShow: notification: %@", notification);
#endif
  
    if ([[self delegate]
               respondsToSelector:@selector(keyboardController:keyboardWillShowWithFrameBegin:frameEnd:animationDuration:animationCurve:)]) {
        [[self delegate] keyboardController:self
             keyboardWillShowWithFrameBegin:[self frameBeginFromNotification:notification]
                                   frameEnd:[self frameEndFromNotification:notification]
                          animationDuration:[self animationDurationFromNotification:notification]
                             animationCurve:[self animationCurveFromNotification:notification]];
    }
}

- (void)keyboardWillHide:(NSNotification *)notification
{
#if DSKeyboardControllerDebug
  NSLog(@"keyboardWillHide: notification: %@", notification);
#endif

    if ([[self delegate]
               respondsToSelector:@selector(keyboardController:keyboardWillHideWithFrameBegin:frameEnd:animationDuration:animationCurve:)]) {
        [[self delegate] keyboardController:self
             keyboardWillHideWithFrameBegin:[self frameBeginFromNotification:notification]
                                   frameEnd:[self frameEndFromNotification:notification]
                          animationDuration:[self animationDurationFromNotification:notification]
                             animationCurve:[self animationCurveFromNotification:notification]];
    }
}

- (void)keyboardDidShow:(NSNotification *)notification
{
#if DSKeyboardControllerDebug
  NSLog(@"keyboardDidShow: notification: %@", notification);
#endif

  
    if ([[self delegate] respondsToSelector:@selector(keyboardController:keyboardDidShowWithFrameBegin:frameEnd:)]) {
        [[self delegate] keyboardController:self
              keyboardDidShowWithFrameBegin:[self frameBeginFromNotification:notification]
                                   frameEnd:[self frameEndFromNotification:notification]];
    }
}

- (void)keyboardDidHide:(NSNotification *)notification
{
#if DSKeyboardControllerDebug
  NSLog(@"keyboardDidHide: notification: %@", notification);
#endif

    if ([[self delegate] respondsToSelector:@selector(keyboardController:keyboardDidHideWithFrameBegin:frameEnd:)]) {
        [[self delegate] keyboardController:self
              keyboardDidHideWithFrameBegin:[self frameBeginFromNotification:notification]
                                   frameEnd:[self frameEndFromNotification:notification]];
    }
}

- (void)keyboardWillChangeFrame:(NSNotification *)notification
{
#if DSKeyboardControllerDebug
  NSLog(@"keyboardWillChangeFrame: notification: %@", notification);
#endif

    if ([[self delegate] respondsToSelector:@selector(keyboardController:willChangeFrameFrom:to:)]) {
        [[self delegate] keyboardController:self
                        willChangeFrameFrom:[self frameBeginFromNotification:notification]
                                         to:[self frameEndFromNotification:notification]];
    }
}

- (void)keyboardDidChangeFrame:(NSNotification *)notification
{
#if DSKeyboardControllerDebug
  NSLog(@"keyboardDidChangeFrame: notification: %@", notification);
#endif

    if ([[self delegate] respondsToSelector:@selector(keyboardController:didChangeFrameFrom:to:)]) {
        [[self delegate] keyboardController:self
                         didChangeFrameFrom:[self frameBeginFromNotification:notification]
                                         to:[self frameEndFromNotification:notification]];
    }
}

#pragma mark - getting information from notification
- (id)valueFromNotification:(NSNotification *)notification
                        key:(NSString *)key
{
    NSDictionary *userInfo = [notification userInfo];
    id value = [userInfo valueForKey:key];
    return value;
}

//UIKIT_EXTERN NSString *const UIKeyboardFrameBeginUserInfoKey        NS_AVAILABLE_IOS(3_2); // NSValue of CGRect
- (CGRect)frameBeginFromNotification:(NSNotification *)notification
{
    NSValue *value = [self valueFromNotification:notification
                                             key:UIKeyboardFrameBeginUserInfoKey];

    if (value) {
        return [value CGRectValue];
    }
    else {
        return CGRectZero;
    }
}

//UIKIT_EXTERN NSString *const UIKeyboardFrameEndUserInfoKey          NS_AVAILABLE_IOS(3_2); // NSValue of CGRect
- (CGRect)frameEndFromNotification:(NSNotification *)notification
{
    NSValue *value = [self valueFromNotification:notification
                                             key:UIKeyboardFrameEndUserInfoKey];

    if (value) {
        return [value CGRectValue];
    }
    else {
        return CGRectZero;
    }
}

//UIKIT_EXTERN NSString *const UIKeyboardAnimationDurationUserInfoKey NS_AVAILABLE_IOS(3_0); // NSNumber of double
- (double)animationDurationFromNotification:(NSNotification *)notification
{
    NSNumber *number = [self valueFromNotification:notification
                                               key:UIKeyboardAnimationDurationUserInfoKey];
    return [number doubleValue];
}

// UIKIT_EXTERN NSString *const UIKeyboardAnimationCurveUserInfoKey    NS_AVAILABLE_IOS(3_0); // NSNumber of NSUInteger (UIViewAnimationCurve)
- (UIViewAnimationCurve)animationCurveFromNotification:(NSNotification *)notification
{
    NSNumber *number = [self valueFromNotification:notification
                                               key:UIKeyboardAnimationCurveUserInfoKey];
    return (UIViewAnimationCurve)[number unsignedIntegerValue];
}
@end
