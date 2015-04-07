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
@property (nonatomic, assign) CGPoint dragStartPoint;

@property (nonatomic, strong) UIView *draggingView;
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
  
  UIView *firstView = [self viewForIndex:0];
  UIView *dontRemoveView = nil;
  if ([[self dataSource] viewStack:self isView:firstView equalToView:self.draggingView]) {
    dontRemoveView = self.draggingView;
  }
  
  for (UIView *subView in self.subviews) {
    if (subView != dontRemoveView) {
      [subView removeFromSuperview];
    }
  }
  
  [self preloadViewsSkipFirst:dontRemoveView != nil];
}

- (UIView *)dequeueReusableView
{
  UIView *reusableView = [[self reusableViews] pop];
  return reusableView;
}

- (BOOL)showNextViewAnimated:(BOOL)animated
          animationDirection:(DSViewsStackAnimationDirection)direction
                       delay:(NSTimeInterval)delay
                    velocity:(CGPoint)velocity
{
  if ([[self delegate] respondsToSelector:@selector(viewsStack:willRemoveViewAtIndex:inDirection:)]) {
    [[self delegate] viewsStack:self
          willRemoveViewAtIndex:[self currentIndex]
                    inDirection:direction];
  }
  
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
                         velocity:velocity];
  
  return increased;
}

- (BOOL)showNextViewAnimated:(BOOL)animated
          animationDirection:(DSViewsStackAnimationDirection)direction
                       delay:(NSTimeInterval)delay
{
  return [self showNextViewAnimated:animated animationDirection:direction delay:delay velocity:CGPointZero];
}

- (BOOL)showNextViewWithoutAnimation
{
  return [self showNextViewAnimated:NO animationDirection:DSViewsStackAnimationDirectionNone delay:0];
}

- (UIView *)topView
{
  return [[self subviews] lastObject];
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

- (BOOL)decreaseCurrentIndex
{
  [self setCurrentIndex:[self currentIndex] - 1];
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
                         velocity:(CGPoint)velocity
{
  UIView *topView = [self topView];
  
  if (animated && topView) {
    [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
    
    if ([[self delegate] respondsToSelector:@selector(viewsStack:willAutomaticallyMoveViewOutOfScreen:direction:)]) {
      [[self delegate] viewsStack:self willAutomaticallyMoveViewOutOfScreen:topView direction:direction];
    }
    
    if (CGPointEqualToPoint(velocity, CGPointZero)) {
      if (direction == DSViewsStackAnimationDirectionLeft) {
        velocity = CGPointMake(-1, 0);
      }
      else if (direction == DSViewsStackAnimationDirectionRight) {
        velocity = CGPointMake(1, 0);
      }
      else if (direction == DSViewsStackAnimationDirectionTop) {
        velocity = CGPointMake(0, -1);
      }
      else if (direction == DSViewsStackAnimationDirectionBottom) {
        velocity = CGPointMake(0, 1);
      }
      velocity.x *= 1500;
      velocity.y *= 1500;
    }
    
    void (^animationBlock)() = ^{
      const CGPoint startCenter = topView.center;
      CGPoint endCenter = startCenter;
      
      const CGFloat viewWidth = self.bounds.size.width;
      const CGFloat viewHeight = self.bounds.size.height;
      
      CGFloat moveDistance = sqrt(pow(viewWidth, 2) + pow(viewHeight, 2));
      const CGFloat v_x = velocity.x;
      const CGFloat v_y = velocity.y;
      CGFloat v_d = sqrt(pow(v_x, 2) + pow(v_y, 2));
      const CGFloat cosAlpha = v_x / v_d;
      const CGFloat sinAlpha = v_y / v_d;
      
      if (v_d < 400) {
        v_d = 400;
      }
      
      const CGFloat d_x = moveDistance * cosAlpha;
      const CGFloat d_y = moveDistance * sinAlpha;
      
      endCenter.x += d_x;
      endCenter.y += d_y;
      
      const NSTimeInterval duration = moveDistance / v_d;
      
      //      if (direction == DSViewsStackAnimationDirectionTop
      //          || direction == DSViewsStackAnimationDirectionBottom) {
      //        x = [self frame].size.width/2.0;
      //        if (direction == DSViewsStackAnimationDirectionTop) {
      //          y = -[topView frame].size.height/2.0;
      //        }
      //        else {
      //          y = [self frame].size.height + [topView frame].size.height/2.0;
      //        }
      //      }
      //
      //      if (direction == DSViewsStackAnimationDirectionLeft ||
      //          direction == DSViewsStackAnimationDirectionRight) {
      //        y = [self frame].size.height/2.0;
      //        if (direction == DSViewsStackAnimationDirectionLeft) {
      //          x = -[topView frame].size.width/2.0;
      //        }
      //        else {
      //          x = +[self frame].size.width + [topView frame].size.width/2.0;
      //        }
      //      }
      
      [UIView animateWithDuration:duration
                       animations:^{
                         [UIView setAnimationCurve:UIViewAnimationCurveLinear];
                         [topView setCenter:endCenter];
                         [self updateViewRotation:topView];
                       } completion:^(BOOL finished) {
                         [[UIApplication sharedApplication] endIgnoringInteractionEvents];
                         [topView removeFromSuperview];
                         completion(topView);
                       }];
    };
    
    if (delay == 0) {
      animationBlock();
    }
    else {
      dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delay * NSEC_PER_SEC)), dispatch_get_main_queue(), animationBlock);
    }
  }
  else if (topView) {
    [topView removeFromSuperview];
    completion(topView);
  }
  else {
    completion(nil);
  }
}

- (void)removeViewFromTopAnimated:(BOOL)animated
                       completion:(void(^)(UIView *))completion
               animationDirection:(DSViewsStackAnimationDirection)direction
                            delay:(NSTimeInterval)delay
{
  [self removeViewFromTopAnimated:animated completion:completion animationDirection:direction delay:delay velocity:CGPointZero];
}

#pragma mark - views moving
- (void)preloadViewsSkipFirst:(BOOL)skipFrist
{
  if ([self currentIndex] < [self numberOfViews] && !skipFrist) {
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

- (void)removeViewAtIndex:(NSUInteger)index
{
  if ([self currentIndex] > index) {
    [self decreaseCurrentIndex];
  }
  else if ([self currentIndex] == index) {
    [self showNextViewWithoutAnimation];
  }
  else if ([self currentIndex] == index - 1){
    [[[self subviews] firstObject] removeFromSuperview];
    [self preloadViewsSkipFirst:NO];
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
    case UIGestureRecognizerStateBegan: {
      CGPoint location = [recognizer locationInView:self];
      [self setDragStartPoint:location];
      self.draggingView = view;
    }
    case UIGestureRecognizerStateChanged: {
      CGPoint location = [recognizer locationInView:self];
      CGPoint center = CGPointMake(CGRectGetMidX([self bounds]), CGRectGetMidY([self bounds]));;
      location.x -= [self dragStartPoint].x - center.x;
      location.y -= [self dragStartPoint].y - center.y;
      [view setCenter:location];

      [self updateViewRotation:view];
    }
      break;
    case UIGestureRecognizerStateEnded:
    case UIGestureRecognizerStateCancelled: {
      self.draggingView = nil;
      CGPoint velocity = [recognizer velocityInView:self];
      DSViewsStackAnimationDirection draggedSide = [self isViewDraggedOut:view velocity:velocity];
      
      __weak DSViewsStack *weakSelf = self;
      
      void (^block)() = ^{
        [weakSelf showNextViewAnimated:YES animationDirection:draggedSide delay:0 velocity:velocity];
      };
      
      if (draggedSide == DSViewsStackAnimationDirectionNone) {
        [weakSelf moveViewToInitialPosition:view animated:YES];
      }
      else {
        if ([[self delegate] respondsToSelector:
             @selector(viewsStack:completionForPreDragReleasedAction:animationDirection:viewIndex:)]) {
          [[self delegate] viewsStack:self completionForPreDragReleasedAction:^(BOOL shouldCancel) {
            if (shouldCancel) {
              [self moveViewToInitialPosition:view animated:YES];
            }
            else {
              block();
            }
          } animationDirection:draggedSide viewIndex:[self currentIndex]];
        }
        else {
          block();
        }
      }      
    }
      
      break;
      
    default:
      break;
  }
}

- (DSViewsStackAnimationDirection)isViewDraggedOut:(UIView *)view velocity:(CGPoint)velocity
{
  CGRect viewFrame = [view frame];
  CGRect boundsFrame = [self bounds];
  
  BOOL leftIntersection = viewFrame.origin.x + 70 < boundsFrame.origin.x;
  BOOL rightIntersection = CGRectGetMaxX(viewFrame) - 70 > CGRectGetMaxX(boundsFrame);
  
  if (leftIntersection && velocity.x < 0) {
    return DSViewsStackAnimationDirectionLeft;
  }
  else if (rightIntersection && velocity.x > 0) {
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
  const CGFloat verticalDelta = ([self dragStartPoint].y -[self getViewsCenter].y);
  const CGFloat verticalAlphaParameter = verticalDelta/([self frame].size.width/2.0);
  
  double alpha = atan(tangensAlpha) * ((verticalAlphaParameter > 0)
                                       ? MAX(verticalAlphaParameter, 0.5)
                                       : MIN (verticalAlphaParameter, -0.5));
  if (iOS7orHigher && !iOS8orHigher) {
    [view setTransform:CGAffineTransformMakeRotation(alpha)];
  }
}

#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
  UIView *topView = [self topView];
  return topView == gestureRecognizer.view;
}
@end
