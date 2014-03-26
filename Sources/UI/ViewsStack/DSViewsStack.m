//
//  DSViewsStack.m
//  DSLib
//
//  Created by Alexander Belyavskiy on 3/25/14.
//  Copyright (c) 2014 DS ltd. All rights reserved.
//

#pragma mark - include
#import "DSViewsStack.h"
#import "DSViewsStackDataSource.h"
#import "DSQueue.h"

@interface DSViewsStack ()
@property (nonatomic, strong) DSQueue *reusableViews;
@property (nonatomic, assign) NSUInteger currentIndex;
@end

@implementation DSViewsStack

- (instancetype)init
{
  self = [super init];
  if (self) {
    _reusableViews = [[DSQueue alloc] init];
  }
  return self;
}

- (NSUInteger)numberOfViews
{
  return [[self dataSource] numberOfViewsInViewsStack:self];
}

- (UIView *)viewForIndex:(NSUInteger)index
{
  return [[self dataSource] viewsStack:self viewForIndex:index];
}

- (void)reloadData
{
  [self resetCurrentIndex];
  
  [self preloadViews];
}

- (UIView *)dequeueReusableView
{
  UIView *reusableView = [[self reusableViews] pop];
  return reusableView;
}

- (BOOL)showNextViewAnimated:(BOOL)animated
{
  UIView *removedView = [self removeViewFromTopAnimated:animated];
  [[self reusableViews] push:removedView];
  
  BOOL increased = [self increaseCurrentIndex];
  
  if (increased) {
    [self preloadViewAtIndex:[self currentIndex] + 1 animated:animated];
  }
  
  return increased;
}

#pragma mark - private
- (void)resetCurrentIndex
{
  [self setCurrentIndex:0];
}

- (BOOL)increaseCurrentIndex
{
  if ([self currentIndex] == [self numberOfViews] - 1) {
    return NO;
  }
  
  [self setCurrentIndex:[self currentIndex] + 1];
  return YES;
}

#pragma mark - subviews management
- (void)addView:(UIView *)view toBackAnimated:(BOOL)animated
{
  [self insertSubview:view atIndex:0];
}

/** @return removed view */
- (UIView *)removeViewFromTopAnimated:(BOOL)animated
{
  UIView *topView = [[self subviews] lastObject];
  [topView removeFromSuperview];
  return topView;
}

#pragma mark - views moving
- (void)preloadViews
{
  if ([self currentIndex] < [self numberOfViews]) {
    UIView *viewForCurrentIndex = [self viewForIndex:[self currentIndex]];
    [self addView:viewForCurrentIndex toBackAnimated:NO];
  }
  if ([self currentIndex] + 1 < [self numberOfViews]) {
    [self addView:[self viewForIndex:[self currentIndex] + 1] toBackAnimated:NO];
  }
}

- (void)preloadViewAtIndex:(NSUInteger)index animated:(BOOL)animated
{
  if (index < [self numberOfViews]) {
    [self addView:[self viewForIndex:index] toBackAnimated:animated];
  }
}

@end
