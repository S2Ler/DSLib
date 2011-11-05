
#import <QuartzCore/QuartzCore.h>
#import "DSSliderDelegate.h"

#define kTextAnimationKey @"textAnimation"
#define kSliderTrackEdgeInset 4

@interface DSSlider : UIView {
  NSString *text;
  UIImage *trackImage;
  UIImage *thumbImage;
	UIImage *backgroundImage;
  
  CGFloat sliderTrackEdgeInset;
  
  UILabel *label;
  UISlider *slider;
  
  CABasicAnimation *textAnimation;
  CAGradientLayer *animationLayer;
  NSArray *gradientLocations;
  NSArray *gradientEndLocations;
  
  BOOL sliderTouchDown;
  
  id delegate;
}

@property (nonatomic, retain) NSString *text;
@property (nonatomic, retain) UIImage *trackImage;
@property (nonatomic, retain) UIImage *thumbImage;
@property (nonatomic, retain) UIImage *backgroundImage;

@property (nonatomic, assign) CGFloat sliderTrackEdgeInset;

@property (nonatomic, assign) id delegate;

- (id) initWithText:(NSString *)t trackImage:(UIImage *)trackImg thumbImage:(UIImage *)thumbImg;
- (id) initWithText:(NSString *)t trackImgName:(NSString *)trackImgName thumbImgName:(NSString *)thumbImgName;

- (void) startTextAnimation;
- (void) stopTextAnimation;
- (void) loadView;

@end
