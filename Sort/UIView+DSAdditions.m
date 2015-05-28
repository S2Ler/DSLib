//
//  UIView+DSAdditions.m
//  DSLib
//
//  Created by Alex on 25/10/2013.
//  Copyright (c) 2013 DS ltd. All rights reserved.
//

#import "UIView+DSAdditions.h"
#import <objc/runtime.h>
#import "DSMacros.h"

@implementation UIView (DSAdditions)
static char kDSTouchHandlerKey;
static char kDSTouchHandlerDimOutViewKey;

- (void)setDimOutView:(UIView *)view
{
  objc_setAssociatedObject(self, &kDSTouchHandlerDimOutViewKey, view, OBJC_ASSOCIATION_ASSIGN);
}

- (UIView *)dimOutView
{
  return objc_getAssociatedObject(self, &kDSTouchHandlerDimOutViewKey);
}

- (void)removeDimOutView
{
  [self removeDimOutViewAnimated:NO animationDuration:0];
}

- (void)removeDimOutViewAnimated:(BOOL)animated animationDuration:(NSTimeInterval)animationDuration
{
  UIView *dimoutView = self.dimOutView;
  [self setDimOutView:nil];
  
  void (^remove)() = ^{
    [dimoutView removeFromSuperview];
  };
  
  if (!animated) {
    remove();
  }
  else {
    [UIView animateWithDuration:animationDuration
                     animations:^{
                       dimoutView.alpha = 0;
                     } completion:^(BOOL finished) {
                       remove();
                     }];
  }
}

- (void)setTouchHandler:(DSViewTouchHandler)touchHandler
{
  objc_setAssociatedObject(self, &kDSTouchHandlerKey, touchHandler, OBJC_ASSOCIATION_COPY_NONATOMIC);
  UITapGestureRecognizer *tapGesture
  = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(_dsTouchedHandler:)];
  [self addGestureRecognizer:tapGesture];
}

- (void)_dsTouchedHandler:(UIGestureRecognizer *)tapGesture
{
  if ([tapGesture state] == UIGestureRecognizerStateRecognized) {
    DSViewTouchHandler touchHandler = [self _touchHandler];
    if (touchHandler) {
      touchHandler(self);
    }
  }
}

- (DSViewTouchHandler)_touchHandler
{
  return objc_getAssociatedObject(self, &kDSTouchHandlerKey);
}

- (UIView *)dimOutViewWithTapHandler:(void(^)())handler
                        animated:(BOOL)animated
               animationDuration:(NSTimeInterval)animationDuration
{
  return [self dimOutViewWithTapHandler:handler
                               animated:animated
                      animationDuration:animationDuration
                            enableSwipe:NO
                         swipeDirection:0];
}

- (UIView *)dimOutViewAnimated:(BOOL)animated
             animationDuration:(NSTimeInterval)animationDuration
{
  return [self dimOutViewWithTapHandler:nil
                               animated:animated
                      animationDuration:animationDuration
                            enableSwipe:NO
                         swipeDirection:0
                            hideOnTouch:^{return NO;}];
}

- (UIView *)dimOutViewWithTapHandler:(void(^)())handler
{
  return [self dimOutViewWithTapHandler:handler animated:false animationDuration:0];
}

- (UIView *)dimOutViewWithTapHandler:(void(^)())handler
                            animated:(BOOL)animated
                   animationDuration:(NSTimeInterval)animationDuration
                         enableSwipe:(BOOL)enableSwipe
                      swipeDirection:(UISwipeGestureRecognizerDirection)swipeDirection
{
  return [self dimOutViewWithTapHandler:handler
                               animated:animated
                      animationDuration:animationDuration
                            enableSwipe:enableSwipe
                         swipeDirection:swipeDirection
                            hideOnTouch:^{return YES;}];
}

- (UIView *)dimOutViewWithTapHandler:(void(^)())handler
                            animated:(BOOL)animated
                   animationDuration:(NSTimeInterval)animationDuration
                         enableSwipe:(BOOL)enableSwipe
                      swipeDirection:(UISwipeGestureRecognizerDirection)swipeDirection
                         hideOnTouch:(BOOL(^)())hideOnTouch
{
  UIView *dimOutView = [[UIView alloc] init];
  [self setDimOutView:dimOutView];
  
  [dimOutView setAutoresizingMask:UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth];
  [dimOutView setTranslatesAutoresizingMaskIntoConstraints:YES];
  [dimOutView setBackgroundColor:[UIColor colorWithWhite:0 alpha:0.55]];
  if (enableSwipe) {
    UISwipeGestureRecognizer *swipeGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:dimOutView
                                                                                       action:@selector(_dsTouchedHandler:)];
    swipeGesture.direction = swipeDirection;
    [dimOutView addGestureRecognizer:swipeGesture];
  }
  
  DSWEAK_SELF;
  [dimOutView setTouchHandler:^(UIView *view) {
    DSSTRONG_SELF;
    
    if (handler) {
      handler();
    }
    
    if (hideOnTouch()) {
      [strongSelf removeDimOutViewAnimated:animated animationDuration:animationDuration];
    }
  }];
  
  [dimOutView setFrame:[self bounds]];
  if (animated) {
    dimOutView.alpha = 0;
  }
  [self addSubview:dimOutView];
  
  if (animated) {
    [UIView animateWithDuration:animationDuration
                     animations:^{
                       dimOutView.alpha = 1;
                     }];
  }
  
  return dimOutView;
}
@end
