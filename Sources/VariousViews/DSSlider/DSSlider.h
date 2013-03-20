
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
  
  id __weak delegate;
}

@property (nonatomic, strong) NSString *text;
@property (nonatomic, strong) UIImage *trackImage;
@property (nonatomic, strong) UIImage *thumbImage;
@property (nonatomic, strong) UIImage *backgroundImage;

@property (nonatomic, assign) CGFloat sliderTrackEdgeInset;

@property (nonatomic, weak) id delegate;

- (id) initWithText:(NSString *)t trackImage:(UIImage *)trackImg thumbImage:(UIImage *)thumbImg;
- (id) initWithText:(NSString *)t trackImgName:(NSString *)trackImgName thumbImgName:(NSString *)thumbImgName;

- (void) startTextAnimation;
- (void) stopTextAnimation;
- (void) loadView;

@end
