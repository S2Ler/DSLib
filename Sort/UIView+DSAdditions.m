//
//  UIView+DSAdditions.m
//  DSLib
//
//  Created by Alex on 25/10/2013.
//  Copyright (c) 2013 DS ltd. All rights reserved.
//

#import "UIView+DSAdditions.h"
#import <objc/runtime.h>

@implementation UIView (DSAdditions)
static char kDSTouchHandlerKey;

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

- (void)dimOutViewWithTapHandler:(void(^)())handler
{
  UIView *dimOutView = [[UIView alloc] init];
  [dimOutView setAutoresizingMask:UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth];
  [dimOutView setTranslatesAutoresizingMaskIntoConstraints:YES];
  [dimOutView setBackgroundColor:[UIColor colorWithWhite:0 alpha:0.2]];
  [dimOutView setTouchHandler:^(UIView *view) {
    if (handler) {
      handler();
    }
    
    [view removeFromSuperview];
  }];
  
  [dimOutView setFrame:[self bounds]];
  [self addSubview:dimOutView];
}

@end
