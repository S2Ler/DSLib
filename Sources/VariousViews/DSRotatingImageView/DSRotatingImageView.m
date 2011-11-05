

#import "DSRotatingImageView.h"
#import <QuartzCore/QuartzCore.h>

#define DEGREES_TO_RADIANS(angle) (angle / 180.0 * M_PI)
#define kRotateAnimationKey @"rotateAnimation"

@implementation DSRotatingImageView
@synthesize rps = _rps;

- (void)generalInit
{
  _rps = 4.0;
}

- (id)initWithFrame:(CGRect)frame
{
  self = [super initWithFrame:frame];
  if (self) {
    [self generalInit];
  }
  return self;
}

- (id)initWithCoder:(NSCoder *)coder {
  self = [super initWithCoder:coder];
  if (self) {
    [self generalInit];
  }
  return self;
}

- (id)initWithImage:(UIImage *)image
{
  self = [super initWithImage:image];
  
  if (self) {
    [self generalInit];
  }
  
  return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (void)startAnimating
{
	CABasicAnimation *rotateAnimation 
  = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
  
	[rotateAnimation setTimingFunction: 
   [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear]];
	[rotateAnimation setFromValue:[NSNumber numberWithFloat:0]];
	[rotateAnimation setToValue:[NSNumber numberWithFloat:((360*M_PI)/180)]];
	[rotateAnimation setRepeatCount:HUGE_VALF];
	[rotateAnimation setDuration:1/[self rps]];
  
  CALayer *selfLayer = [self layer];
  
	[selfLayer addAnimation:rotateAnimation
                   forKey:kRotateAnimationKey];
}

- (void)endAnimating
{
  [[self layer] removeAnimationForKey:kRotateAnimationKey];
}

@end
