

#import <UIKit/UIKit.h>

@interface PGSlider : UIView
/** Sets text for the slider. Animated text */
- (void)setText:(NSString *)theText;
@property (retain, nonatomic) IBOutlet UIView *sliderPlaceHolder;
@property (nonatomic, copy) dispatch_block_t onSlideRightMostHandler;
@end
