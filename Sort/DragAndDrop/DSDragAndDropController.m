//
// Created by Alex on 10/10/13.
// Copyright (c) 2013 DS ltd. All rights reserved.
//

#pragma mark - include
#import "DSDragAndDropController.h"
#import "DSDraggingSourceContainer.h"
#import "DSDraggingDestinationContainer.h"
#import "UIView+Subviews.h"

@interface DSDragAndDropController ()
@property (nonatomic, weak) UIView <DSDraggingSourceContainer> *source;
@property (nonatomic, weak) UIView <DSDraggingDestinationContainer> *destination;
@property (nonatomic, weak) UIView *draggingArea;
@property (nonatomic, strong) UIImageView *snapshotImageView;
@property (nonatomic, assign) CGRect initialFrame;
@property (nonatomic, strong) id draggingModelObject;
@end

@implementation DSDragAndDropController

- (id)initWithSource:(UIView<DSDraggingSourceContainer> *)source
         destination:(UIView<DSDraggingDestinationContainer> *)destination
        draggingArea:(UIView *)draggingArea
{
  self = [super init];
  if (self) {
    _source = source;
    _destination = destination;
    _draggingArea = draggingArea;
    
    [self setupGestures];
  }
  return self;
}

- (void)setupGestures {
  UILongPressGestureRecognizer *longPressGestureRecognizer
  = [[UILongPressGestureRecognizer alloc] initWithTarget:self
                                                  action:@selector(sourceLongPressedGesture:)];
  [[self source] addGestureRecognizer:longPressGestureRecognizer];
}

- (void)sourceLongPressedGesture:(UILongPressGestureRecognizer *)gesture
{
  if ([gesture state] == UIGestureRecognizerStateBegan) {
    
    id modelObject = nil;
    UIView *draggingView = [[self source] dragginViewAtLocation:[gesture locationInView:[self source]]
                                                 getModelObject:&modelObject];
    [self setDraggingModelObject:modelObject];
    UIImage *snapshot = [draggingView getSnapshot];
    UIImageView *snapshotImageView = [[UIImageView alloc] initWithImage:snapshot];
    [snapshotImageView setFrame:[[self source] convertRect:[draggingView frame] toView:[self draggingArea]]];
    snapshotImageView.clipsToBounds = NO;

    [UIView animateWithDuration:0.5 animations:^{
      [snapshotImageView setTransform:CGAffineTransformMakeScale(0.6, 0.6)];
      snapshotImageView.layer.shadowColor = [UIColor blackColor].CGColor;
      snapshotImageView.layer.shadowOffset = CGSizeMake(0, 5);
      snapshotImageView.layer.shadowOpacity = 0.5;
      snapshotImageView.layer.shadowRadius = 10.0;
    }];

    [[self draggingArea] addSubview:snapshotImageView];
    
    [self setSnapshotImageView:snapshotImageView];
    [self setInitialFrame:[snapshotImageView frame]];
  }
  else if ([gesture state] == UIGestureRecognizerStateChanged) {
    [[self snapshotImageView] setCenter:[gesture locationInView:[self draggingArea]]];
    
    CGRect destinationFrame = [self destinationFrameInDraggingArea];
    if (CGRectIntersectsRect(destinationFrame, [[self snapshotImageView] frame])) {
      [[self destination] setHighlighted:YES];
    }
    else {
      [[self destination] setHighlighted:NO];
    }
  }
  else if (([gesture state] == UIGestureRecognizerStateEnded
            || [gesture state] == UIGestureRecognizerStateCancelled)
           && !CGRectIntersectsRect([self destinationFrameInDraggingArea], [[self snapshotImageView] frame])) {
    [UIView animateWithDuration:0.5 animations:^{
      [[self snapshotImageView] setFrame:[self initialFrame]];
    } completion:^(BOOL finished) {
      [UIView animateWithDuration:0.5 animations:^{
        [[self snapshotImageView] setTransform:CGAffineTransformMakeScale(0, 0)];
      } completion:^(BOOL finished) {
        [[self snapshotImageView] removeFromSuperview];
        [self cleanup];
      }];
    }];
  } else if (CGRectIntersectsRect([self destinationFrameInDraggingArea], [[self snapshotImageView] frame])) {
    [[self destination] setHighlighted:NO];
    [[self destination] consumeModelObject:[self draggingModelObject]];
    [UIView animateWithDuration:0.5
                     animations:^{
                       [[self snapshotImageView] setTransform:CGAffineTransformMakeScale(0, 0)];
                     } completion:^(BOOL finished) {
                       [[self snapshotImageView] removeFromSuperview];
                       [self cleanup];
                     }];
  }
  else {
    NSAssert(FALSE, @"this scenario isn't tested");
    [[self snapshotImageView] removeFromSuperview];
    [self cleanup];
  }
}

- (void)cleanup
{
  [self setSnapshotImageView:nil];
  [self setInitialFrame:CGRectZero];
  [self setDraggingModelObject:nil];
}

- (CGRect)destinationFrameInDraggingArea
{
  CGRect destinationFrame = [[self destination] frame];
  destinationFrame = [[self draggingArea] convertRect:destinationFrame fromView:[self destination]];
  return destinationFrame;
}

@end