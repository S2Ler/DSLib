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
- (void)dimOutViewWithTapHandler:(void(^)())handler;
- (void)dimOutViewWithTapHandler:(void(^)())handler
                        animated:(BOOL)animated
               animationDuration:(NSTimeInterval)animationDuration;
@end
