//
//  UIView+DSAdditions.h
//  DSLib
//
//  Created by Alex on 25/10/2013.
//  Copyright (c) 2013 DS ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^DSViewTouchHandler)(UIView *view);

@interface UIView (DSAdditions)
- (void)setTouchHandler:(DSViewTouchHandler)touchHandler;

- (UIView *)dimOutView;
- (void)removeDimOutView;
- (void)removeDimOutViewAnimated:(BOOL)animated animationDuration:(NSTimeInterval)animationDuration;

- (UIView *)dimOutViewAnimated:(BOOL)animated
             animationDuration:(NSTimeInterval)animationDuration;
- (UIView *)dimOutViewWithTapHandler:(void(^)())handler
                        animated:(BOOL)animated
               animationDuration:(NSTimeInterval)animationDuration;
- (UIView *)dimOutViewWithTapHandler:(void(^)())handler
                        animated:(BOOL)animated
               animationDuration:(NSTimeInterval)animationDuration
                     enableSwipe:(BOOL)enableSwipe
                  swipeDirection:(UISwipeGestureRecognizerDirection)swipeDirection;
- (UIView *)dimOutViewWithTapHandler:(void(^)())handler
                            animated:(BOOL)animated
                   animationDuration:(NSTimeInterval)animationDuration
                         enableSwipe:(BOOL)enableSwipe
                      swipeDirection:(UISwipeGestureRecognizerDirection)swipeDirection
                         hideOnTouch:(BOOL(^)())hideOnTouch;


- (UIView *)dimOutViewWithTapHandler:(void(^)())handler;

@end
