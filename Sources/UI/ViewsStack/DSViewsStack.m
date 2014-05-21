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
#import "DSViewsStackDelegate.h"
#import "DSQueue.h"
#import "DSMacros.h"

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

- (id)init
{
  return [self initWithFrame:CGRectZero];
}

- (NSUInteger)numberOfViews
{
  return [[self dataSource] numberOfViewsInViewsStack:self];
}

- (UIView *)viewForIndex:(NSUInteger)index
{
  UIView *view = [[self dataSource] viewsStack:self viewForIndex:index];
  [view setTransform:CGAffineTransformIdentity];
  return view;
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
          animationDirection:(DSViewsStackAnimationDirection)direction
                       delay:(NSTimeInterval)delay
{
  BOOL increased = [self increaseCurrentIndex];
  
  [self removeViewFromTopAnimated:animated
                       completion:^(UIView *removedView) {
                         if (increased) {
                           [[self reusableViews] push:removedView];
                           [self preloadViewAtIndex:[self currentIndex] + 1 animated:NO];
                         }
                       }
               animationDirection:direction
                            delay:delay
];
  
  return increased;
}

- (BOOL)showNextViewWithoutAnimation
{
  return [self showNextViewAnimated:NO animationDirection:DSViewsStackAnimationDirectionNone delay:0];
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
  [view setFrame:[self bounds]];
  [self moveViewToInitialPosition:view animated:animated];
  
  [self setupDraggingForView:view];
}

/** @return removed view */
- (void)removeViewFromTopAnimated:(BOOL)animated
                       completion:(void(^)(UIView *))completion
               animationDirection:(DSViewsStackAnimationDirection)direction
                            delay:(NSTimeInterval)delay
{
  UIView *topView = [[self subviews] lastObject];
  
  if (animated && topView) {
    [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
    
    if ([[self delegate] respondsToSelector:@selector(viewsStack:willAutomaticallyMoveViewOutOfScreen:direction:)]) {
      [[self delegate] viewsStack:self willAutomaticallyMoveViewOutOfScreen:topView direction:direction];
    }

    DISPATCH_AFTER_SECONDS(delay, ^{
      [UIView animateWithDuration:0.25
                       animations:^{
                         CGFloat x = 0;// = -[topView frame].size.width/2.0;
                         CGFloat y = 0;// = [self frame].size.height/2.0;
                         
                         if (direction == DSViewsStackAnimationDirectionTop
                             || direction == DSViewsStackAnimationDirectionBottom) {
                           x = [self frame].size.width/2.0;
                           if (direction == DSViewsStackAnimationDirectionTop) {
                             y = -[topView frame].size.height/2.0;
                           }
                           else {
                             y = [self frame].size.height + [topView frame].size.height/2.0;
                           }
                         }
                         
                         if (direction == DSViewsStackAnimationDirectionLeft ||
                             direction == DSViewsStackAnimationDirectionRight) {
                           y = [self frame].size.height/2.0;
                           if (direction == DSViewsStackAnimationDirectionLeft) {
                             x = -[topView frame].size.width/2.0;
                           }
                           else {
                             x = +[self frame].size.width + [topView frame].size.width/2.0;
                           }
                         }
                         
                         [topView setCenter:CGPointMake(x, y)];
                         [self updateViewRotation:topView];
                       } completion:^(BOOL finished) {
                         [[UIApplication sharedApplication] endIgnoringInteractionEvents];
                         [topView removeFromSuperview];
                         completion(topView);
                       }];
    });
    
    
  }
  else if (topView) {
    [topView removeFromSuperview];
    completion(topView);
  }
  else {
    completion(nil);
  }
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
  static CGPoint startPoint;
  switch ([recognizer state]) {
    case UIGestureRecognizerStateBegan: {
      CGPoint location = [recognizer locationInView:self];
      startPoint = location;
    }
    case UIGestureRecognizerStateChanged: {
      CGPoint location = [recognizer locationInView:self];
      CGPoint center = CGPointMake(CGRectGetMidX([self bounds]), CGRectGetMidY([self bounds]));;
      location.x -= startPoint.x - center.x;
      location.y -= startPoint.y - center.y;
      [view setCenter:location];

      [self updateViewRotation:view];
    }
      break;
    case UIGestureRecognizerStateEnded:
    case UIGestureRecognizerStateCancelled: {
      DSViewsStackAnimationDirection draggedSide = [self isViewDraggedOut:view];
      
      if (draggedSide == DSViewsStackAnimationDirectionNone) {
        [self moveViewToInitialPosition:view animated:YES];
      }
      else {
        [self showNextViewAnimated:YES animationDirection:draggedSide delay:0];
      }
    }
      
      break;
      
    default:
      break;
  }
}

- (DSViewsStackAnimationDirection)isViewDraggedOut:(UIView *)view
{
  CGRect viewFrame = [view frame];
  CGRect boundsFrame = [self bounds];
  
  BOOL leftIntersection = viewFrame.origin.x + 150 < boundsFrame.origin.x;
  BOOL rightIntersection = CGRectGetMaxX(viewFrame) - 150 > CGRectGetMaxX(boundsFrame);
  
  if (leftIntersection) {
    return DSViewsStackAnimationDirectionLeft;
  }
  else if (rightIntersection) {
    return DSViewsStackAnimationDirectionRight;
  }
  
  return DSViewsStackAnimationDirectionNone;
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

- (void)updateViewRotation:(UIView *)view {
  double tangensAlpha = ([view center].x - [self getViewsCenter].x)/ROTATION_RADIUS;
  double alpha = atan(tangensAlpha);
  [view setTransform:CGAffineTransformMakeRotation(alpha)];
}

@end
