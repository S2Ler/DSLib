//
//  DSViewsStack.h
//  DSLib
//
//  Created by Alexander Belyavskiy on 3/25/14.
//  Copyright (c) 2014 DS ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DSViewsStackDelegate;
@protocol DSViewsStackDataSource;

typedef NS_ENUM(NSUInteger, DSViewsStackAnimationDirection) {
  DSViewsStackAnimationDirectionNone = 0,
  DSViewsStackAnimationDirectionLeft,
  DSViewsStackAnimationDirectionBottom,
  DSViewsStackAnimationDirectionRight,
  DSViewsStackAnimationDirectionTop
};

@interface DSViewsStack : UIView
@property (nonatomic, weak) id<DSViewsStackDelegate> delegate;
@property (nonatomic, weak) id<DSViewsStackDataSource> dataSource;

- (UIView *)dequeueReusableView;

- (NSUInteger)numberOfViews;
- (UIView *)viewForIndex:(NSUInteger)index;
- (BOOL)showNextViewAnimated:(BOOL)animated animationDirection:(DSViewsStackAnimationDirection)direction;

- (void)reloadData;
@end
