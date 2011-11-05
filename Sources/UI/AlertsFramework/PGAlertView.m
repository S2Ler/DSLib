
#pragma mark - include
#import "PGAlertView.h"
#import "PGAlertContentView.h"
#import "PGAlertSkinView.h"

#pragma mark - Private
@interface PGAlertView() {
  PGAlertSkinView *_skinView;
  PGAlertContentView *_contentView;
}

@property (nonatomic, assign) PGAlertSkinView *skinView;
@property (nonatomic, assign) PGAlertContentView *contentView;
@end

@implementation PGAlertView
@synthesize skinView = _skinView;
@synthesize contentView = _contentView;

#pragma mark - memory
- (void)dealloc
{
  //skinView and contentView is retained by super class UIView.
  
  [super dealloc];    
}

#pragma mark - init
- (id)showInView:(UIView *)theRootView
     contentView:(PGAlertContentView *)theContentView
        animated:(BOOL)theAnimationFlag
            skin:(PGAlertSkinView *)theSkinView
{
  self = [super initWithFrame:[theRootView bounds]];
  
  if (self) {    
    _contentView = theContentView;
    _skinView = theSkinView;
    
    [_skinView setFrame:[self bounds]];
    [self addSubview:_skinView];
    [_skinView setUserInteractionEnabled:YES];
    
    UITapGestureRecognizer *dismissGesture
    = [[UITapGestureRecognizer alloc] initWithTarget:self
                                              action:@selector(hideAnimated)];
    [_skinView addGestureRecognizer:dismissGesture];
    [dismissGesture release];
    
    [_contentView setFrame:[_skinView contentViewFrame]];
    [_skinView addSubview:_contentView];
    [_contentView setUserInteractionEnabled:YES];
    
    [theRootView addSubview:self];
    
    [self showAnimated:theAnimationFlag];
  }
  
  return self;
}

#pragma mark - public

#pragma mark - animation
- (void)hideAnimated:(BOOL)theAnimationFlag
{
  if (theAnimationFlag) {
    [UIView animateWithDuration:0.25
                     animations:
     ^(void) {
       [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
       [self setTransform:CGAffineTransformMakeScale(0.5, 0.5)];
       [self setAlpha:0.0];
     }
                     completion:
     ^(BOOL finished) {     
       [[UIApplication sharedApplication] endIgnoringInteractionEvents];
       [self removeFromSuperview];
       [self setAlpha:1.0];
     }];
  } else {
    [self removeFromSuperview];
  }
}

- (void)hideAnimated 
{
  [self hideAnimated:YES];
}

- (void)showAnimated:(BOOL)theAnimationFlag
{
  [self setHidden:NO];
  
  if (theAnimationFlag) {
    [self setTransform:CGAffineTransformMakeScale(3, 3)];
    [self setAlpha:0];
  }
  
  if (theAnimationFlag) {
    [UIView animateWithDuration:0.25
                     animations:^(void) {
                       [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
                       [self setTransform:CGAffineTransformIdentity];
                       [self setAlpha:1];
                     }
                     completion:^(BOOL finished) {
                       [[UIApplication sharedApplication] endIgnoringInteractionEvents];
                     }];
  }
  
  [[self superview] bringSubviewToFront:self];
}

@end
