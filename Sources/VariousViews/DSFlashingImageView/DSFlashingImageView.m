
#pragma mark - include
#import "DSFlashingImageView.h"
#import <QuartzCore/QuartzCore.h>
#import "CATransition+AnimationsBuilder.h"
#import "PGTimeFunctions.h"
#import "NSArray+Extras.h"

#define FADE_ANIMATION_KEY @"animation.fade"
#define SCALE_ANIMATION_KEY @"animation.scale"
#define kPGAnimationFlashDuration 1.0

#pragma mark - private
@interface DSFlashingImageView() {
  @protected
  NSArray *_flashImages;
  
  BOOL _isFlashingEnabled;
  NSTimeInterval _flashInterval;
  
  BOOL _pulsingEnabled;
  
  NSUInteger _flashFrame;
}

@property (nonatomic, assign) BOOL isFlashingEnabled;
@property (nonatomic, assign) NSTimeInterval flashInterval;
@property (nonatomic, assign) BOOL pulsingEnabled;

- (void)setImage:(UIImage *)image 
        animated:(BOOL)theAnimationFlag;

- (void)updateAnimation;
- (UIImage *)nextImage;
- (NSUInteger)nextFrame;

- (void)scheduleUpdateAnimation;
- (void)unscheduleUpdateAnimation;

@end

@implementation DSFlashingImageView
@synthesize flashImages = _flashImages;
@synthesize isFlashingEnabled = _isFlashingEnabled;
@synthesize flashInterval = _flashInterval;
@synthesize pulsingEnabled = _pulsingEnabled;

- (void)generalInit
{
  _flashInterval = NSTimeIntervalWithSeconds(3.0);
}

- (id)init {
  self = [super init];
  if (self) {
    [self generalInit];
  }
  return self;
}

- (id)initWithFrame:(CGRect)frame
{
  self = [super initWithFrame:frame];
  if (self) {    
    [self generalInit];
  }
  return self;
}

- (id)initWithCoder:(NSCoder *)coder 
{
  self = [super initWithCoder:coder];
  if (self) {    
    [self generalInit];
  }
  return self;
}

- (void)willMoveToSuperview:(UIView *)newSuperview
{
  [super willMoveToSuperview:newSuperview];
  
  [self setImage:[[self flashImages] firstObject]];
}

- (void)setIsFlashingEnabled:(BOOL)theFlashFlag
                     timeout:(NSTimeInterval)theTimeout
{
  [self setFlashInterval:theTimeout];
  [self setIsFlashingEnabled:theFlashFlag];
  [self updateAnimation];
}

- (void)setImage:(UIImage *)theImage 
        animated:(BOOL)theAnimationFlag
{
  if (theAnimationFlag) {
    CAAnimation *fadeAnimation = [CATransition transationForFadeWithDuration:kPGAnimationFlashDuration];
    
    [[self layer] addAnimation:fadeAnimation
                        forKey:FADE_ANIMATION_KEY];
  } else {
    [[self layer] removeAnimationForKey:FADE_ANIMATION_KEY];
  }
  
  [self setImage:theImage];
}

- (void)updateAnimation
{
  if ([self isFlashingEnabled]) {
    UIImage *nextImage = [self nextImage];
        
    [self setImage:nextImage
          animated:YES];
    
    [self scheduleUpdateAnimation];
  } else {
    [self unscheduleUpdateAnimation];
    [self setImage:[[self flashImages] firstObject]
          animated:NO];
  }
}

- (UIImage *)nextImage
{
  UIImage *nextImage = [[self flashImages] objectAtIndex:[self nextFrame]];
  return nextImage;
}

- (NSUInteger)nextFrame
{  
  NSUInteger maxFrame = [[self flashImages] count] - 1;
  _flashFrame++;
  
  if (_flashFrame > maxFrame) {
    _flashFrame = 0;
  }
  
  return _flashFrame;
}

- (void)scheduleUpdateAnimation
{
  [self performSelector:@selector(updateAnimation)
             withObject:nil 
             afterDelay:[self flashInterval]];
}

- (void)unscheduleUpdateAnimation
{
  [[self class] 
   cancelPreviousPerformRequestsWithTarget:self
   selector:@selector(updateAnimation)
   object:nil];
}

- (void)setPulsingEnabled:(BOOL)thePulsingFlag
                 duration:(NSTimeInterval)thePulseDuration
                 minScale:(double)theMinScale
                 maxScale:(double)theMaxScale
{
  [self willChangeValueForKey:@"pulsingEnabled"];
  
  BOOL doAnimation = thePulsingFlag = YES && _pulsingEnabled != thePulsingFlag;
  _pulsingEnabled = thePulsingFlag;
  
  if (doAnimation) {
    CABasicAnimation* shrinkAnimation 
    = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    
    [shrinkAnimation setFromValue:[NSNumber numberWithDouble:theMinScale]];
    [shrinkAnimation setToValue:[NSNumber numberWithDouble:theMaxScale]];
    [shrinkAnimation setDuration:thePulseDuration];
    [shrinkAnimation setRepeatCount:FLT_MAX];
    [shrinkAnimation setRemovedOnCompletion:NO];
    [shrinkAnimation setAutoreverses:YES];
    [[self layer] addAnimation:shrinkAnimation
                       forKey:SCALE_ANIMATION_KEY];
  } else {
    [[self layer] removeAnimationForKey:SCALE_ANIMATION_KEY];
  }
  
  [self didChangeValueForKey:@"pulsingEnabled"];
}

@end
