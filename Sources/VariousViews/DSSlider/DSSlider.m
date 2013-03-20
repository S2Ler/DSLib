

#import "DSSlider.h"

@interface DSSlider()

@end

@implementation DSSlider

@synthesize text;
@synthesize trackImage;
@synthesize thumbImage;
@synthesize backgroundImage;

@synthesize sliderTrackEdgeInset;

@synthesize delegate;

- (id)init {
  self = [super init];
                      
  // set default value for slider track edge inset
  [self setSliderTrackEdgeInset:kSliderTrackEdgeInset];

  return self;
}


- (id)initWithText:(NSString *)theText 
        trackImage:(UIImage *)theTrackImg
        thumbImage:(UIImage *)theThumbImg
{
  self = [self init];
  if (self) {
    [self setText:theText];
    [self setTrackImage:theTrackImg];
    [self setThumbImage:theThumbImg];
		[self setBackgroundImage:[UIImage imageNamed:@"slider_background@2x.png"]];
  }
  
  return self;
}

- (id)initWithText:(NSString *)theText 
       trackImgName:(NSString *)theTrackImgName 
       thumbImgName:(NSString *)theThumbImgName 
{
  return [self initWithText:theText
                 trackImage:[UIImage imageNamed:theTrackImgName]
                 thumbImage:[UIImage imageNamed:theThumbImgName]];
}

- (void)loadView {
	
  UIImageView *sliderBackground = [[UIImageView alloc] initWithImage:trackImage];
  
  // Create the superview same size as track backround, and add the background image to it
  UIView *sliderView = [[UIView alloc] initWithFrame:sliderBackground.frame];
	
  [sliderView addSubview:sliderBackground];
  
	
  // Add the slider with correct geometry centered over the track
  slider = [[UISlider alloc] initWithFrame:[sliderBackground frame]];
  CGRect sliderFrame = [slider frame];
  
  // leave 2 pixels from each edge of the track
  sliderFrame.size.width -= sliderTrackEdgeInset; 
  [slider setFrame:sliderFrame];
  [slider setCenter:[sliderBackground center]];
  [slider setBackgroundColor:[UIColor clearColor]];
  [slider setThumbImage:thumbImage forState:UIControlStateNormal];
  [slider setMinimumValue:0.0f];
  [slider setMaximumValue:1.0f];
  [slider setContinuous:YES];
  [slider setValue:0.0f];
  
  // Set the slider action methods
  [slider addTarget:self action:@selector(sliderUp:) forControlEvents:UIControlEventTouchUpInside];
  [slider addTarget:self action:@selector(sliderDown:) forControlEvents:UIControlEventTouchDown];
  [slider addTarget:self action:@selector(sliderChanged:) forControlEvents:UIControlEventValueChanged];
  
  UIImage *sliderTrackMin = [[UIImage alloc] init];
  UIImage *sliderTrackMax = [[UIImage alloc] init];
  [slider setMinimumTrackImage:sliderTrackMin forState:UIControlStateNormal];
  [slider setMaximumTrackImage:sliderTrackMax forState:UIControlStateNormal];
  
  [sliderView addSubview:slider];
  
  [sliderView setAutoresizingMask:(UIViewAutoresizingFlexibleWidth |
                                   UIViewAutoresizingFlexibleHeight)];
  [self setBounds:[sliderView bounds]];
  [self addSubview:sliderView];
  
  // label on slider track
  UIFont *labelFont = [UIFont systemFontOfSize:24];
  CGSize labelSize = [text sizeWithFont:labelFont];
  label = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.0, labelSize.width, labelSize.height)];
  [label setTextColor:[UIColor whiteColor]];
  [label setTextAlignment:UITextAlignmentCenter];
  [label setAdjustsFontSizeToFitWidth:YES];
  [label setMinimumFontSize:10.0];
  [label setBackgroundColor:[UIColor clearColor]];
  [label setFont:labelFont];
  [label setText:text];
  
  // get label's layer to add animation on it
  CALayer *textLayer = [label layer];
  CGFloat textWidth = [label frame].size.width;
  CGFloat textHeight = [label frame].size.height;
  
  CGFloat x = thumbImage.size.width + (sliderFrame.size.width - [thumbImage size].width - textWidth) / 2.0f;
  CGFloat y = (sliderFrame.size.height - textHeight) / 2.0f;
  [textLayer setFrame:CGRectMake(x, y, textWidth, textHeight)];
  
  animationLayer = [CAGradientLayer layer];
  [animationLayer setFrame:CGRectMake(-textWidth * 1.0f, 0.0f, textWidth * 2.5f, textHeight)];
  [animationLayer setBackgroundColor:[[UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:0.30f] CGColor]];
  
  UIColor *transparentColor = [UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:1.0f];
  NSArray *colors = [NSArray arrayWithObjects:(id)[[UIColor clearColor] CGColor],
                     (id)[transparentColor CGColor],
                     (id)[[UIColor clearColor] CGColor], nil];
  
  gradientLocations = [NSArray arrayWithObjects:[NSNumber numberWithFloat:0.0],
                       [NSNumber numberWithFloat:0.10],
                       [NSNumber numberWithFloat:0.20], nil];
  
  gradientEndLocations = [NSArray arrayWithObjects:[NSNumber numberWithFloat:0.80],
                          [NSNumber numberWithFloat:0.90],
                          [NSNumber numberWithFloat:1.0], nil];
  
  [animationLayer setColors:colors];
  [animationLayer setLocations:gradientLocations];
  
  [animationLayer setStartPoint:CGPointMake(0.0, 0.0)];
  [animationLayer setEndPoint:CGPointMake(1.0, 0.0)];
  
  [textLayer setMask:animationLayer];
  [[self layer] addSublayer:textLayer];
}

- (void) startTextAnimation {
  [label setAlpha:1.0];
  
  textAnimation = [CABasicAnimation animationWithKeyPath:@"locations"];
  [textAnimation setFromValue:gradientLocations];
  [textAnimation setToValue:gradientEndLocations];
  [textAnimation setFillMode:kCAFillModeForwards];
  [textAnimation setRepeatCount:HUGE_VALF];
  [textAnimation setDuration:4.0f];
  [textAnimation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear]];
  [animationLayer addAnimation:textAnimation forKey:kTextAnimationKey];
}

- (void) stopTextAnimation {
  [animationLayer removeAnimationForKey:kTextAnimationKey];
}

- (void) sliderUp:(UISlider *)sender {
  if (!sliderTouchDown) {
    return;
  }
  
  sliderTouchDown = NO;
  
  if ([slider value] > 0.95) {
    [delegate sliderDidSlideRightMost:self];
  }
  [slider setValue:0.0 animated:YES];
  [self startTextAnimation];
}

- (void) sliderDown:(UISlider *)sender {
  sliderTouchDown = YES;
}

- (void) sliderChanged:(UISlider *)sender {
  [label setAlpha:MAX(0.0, 1.0 - ([slider value] * 3.5))];
  
  // stop the animation
  if ([slider value] != 0) {
    [self stopTextAnimation];
  }
}

- (void)setText:(NSString *)theText
{
  if (text != theText) {
    text = theText;
    [label setText:theText];
  }
}

@end

