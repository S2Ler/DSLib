//
// Created by Alex on 10/10/13.
// Copyright (c) 2013 DS ltd. All rights reserved.
//


@import Foundation;

@protocol DSDraggingDestinationContainer <NSObject>
- (void)setHighlighted:(BOOL)highlighted;
- (void)consumeModelObject:(id)modelObject;
@end