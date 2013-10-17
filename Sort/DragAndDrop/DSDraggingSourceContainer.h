//
// Created by Alex on 10/10/13.
// Copyright (c) 2013 DS ltd. All rights reserved.
//


#import <Foundation/Foundation.h>

@protocol DSDraggingSourceContainer <NSObject>
- (void)addGestureRecognizer:(UIGestureRecognizer *)gestureRecognizer;
- (UIView *)dragginViewAtLocation:(CGPoint)location getModelObject:(id*)modelObject;
@end