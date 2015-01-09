//
//  DSViewsStackDelegate.h
//  DSLib
//
//  Created by Alexander Belyavskiy on 3/25/14.
//  Copyright (c) 2014 DS ltd. All rights reserved.
//

@import Foundation;

@protocol DSViewsStackDelegate <NSObject>
@optional

- (void)    viewsStack:(DSViewsStack *)viewsStack
 willRemoveViewAtIndex:(NSUInteger)viewIndex
           inDirection:(DSViewsStackAnimationDirection)direction;

- (void)                   viewsStack:(DSViewsStack *)viewsStack
 willAutomaticallyMoveViewOutOfScreen:(UIView *)view
                            direction:(DSViewsStackAnimationDirection)direction;

- (void)                 viewsStack:(DSViewsStack *)viewsStack
 completionForPreDragReleasedAction:(void(^)(BOOL shouldCancel))completion
                 animationDirection:(DSViewsStackAnimationDirection)direction
                          viewIndex:(NSUInteger)viewIndex;

@end
