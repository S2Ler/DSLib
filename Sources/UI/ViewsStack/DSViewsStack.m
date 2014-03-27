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

#define ROTATION_RADIUS 400

@interface DSViewsStack ()<UIGestureRecognizerDelegate>
@property (nonatomic, strong) DSQueue *reusableViews;
@property (nonatomic, assign) NSUInteger currentIndex;
@end

@implementation DSViewsStack

- (void)sharedInit
{
  _reusableViews = [[DSQueue alloc] init];
}

- (instancetype)initWithFrame:(CGRect)frame
{
  self = [super initWithFrame:frame];
  if (self) {
    [self sharedInit];
  }
  return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
  self = [super initWithCoder:aDecoder];
  if (self) {
    [self sharedInit];
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
  
  [view setCenter:CGPointMake(-[view frame].size.width/2.0, [self frame].size.height/2.0)];
  [self moveViewToInitialPosition:view animated:animated];
  
  [self setupDraggingForView:view];
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

#pragma mark - dragging
- (void)setupDraggingForView:(UIView *)view
{
  NSArray *gestureRecognizer = [view gestureRecognizers];
  for (UIGestureRecognizer *recognizer in gestureRecognizer) {
    if ([recognizer delegate] == self && [recognizer isKindOfClass:[UIPanGestureRecognizer class]]) {
      return;//already set up
    }
  }
  
  UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self
                                                                               action:@selector(viewDragging:)];
  [panGesture setDelegate:self];
  [view addGestureRecognizer:panGesture];
}

- (void)viewDragging:(UIPanGestureRecognizer *)recognizer
{
  UIView *view = [recognizer view];
  
  switch ([recognizer state]) {
    case UIGestureRecognizerStateChanged: {
      CGPoint location = [recognizer locationInView:self];
      [view setCenter:location];
      
      double tangensAlpha = (location.x - [self getViewsCenter].x)/ROTATION_RADIUS;
      double alpha = atan(tangensAlpha);
      [view setTransform:CGAffineTransformMakeRotation(alpha)];
    }
      break;
    case UIGestureRecognizerStateEnded:
    case UIGestureRecognizerStateCancelled: {
      if ([self isViewDraggedOut:view]) {
        [self showNextViewAnimated:YES];
      }
      else {
        [self moveViewToInitialPosition:view animated:YES];
      }
    }
      
      break;
      
    default:
      break;
  }
}

- (BOOL)isViewDraggedOut:(UIView *)view
{
  CGRect viewFrame = [view frame];
  CGRect boundsFrame = [self bounds];
  
  BOOL leftIntersection = viewFrame.origin.x < boundsFrame.origin.x;
  BOOL rightIntersection = CGRectGetMaxX(viewFrame) > CGRectGetMaxX(boundsFrame);
  return leftIntersection || rightIntersection;
}

- (void)moveViewToInitialPosition:(UIView *)view animated:(BOOL)animated
{
  if (animated) {
    [UIView beginAnimations:nil context:nil];
  }
    [view setCenter:[self getViewsCenter]];
  [view setTransform:CGAffineTransformIdentity];
  
  if (animated) {
    [UIView commitAnimations];
  }
}

- (CGPoint)getViewsCenter
{
  return CGPointMake([self frame].size.width/2.0, [self frame].size.height/2.0);
}
@end
