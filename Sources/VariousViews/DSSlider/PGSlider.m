
#import "PGSlider.h"
#import "DSSlider.h"

@interface PGSlider()

@end

@implementation PGSlider {
  dispatch_block_t _onSlideRightMostHandler;
  DSSlider *_slider;
}
@synthesize sliderPlaceHolder;
@synthesize onSlideRightMostHandler = _onSlideRightMostHandler;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib
{
  DSSlider *slider = [[DSSlider alloc] initWithText:@"slide to cancel" 
                                       trackImgName:@"slidertrack.png"
                                       thumbImgName:@"sliderthumb.png"];
  
  [slider setFrame:[[self sliderPlaceHolder] bounds]];
  [slider loadView];
  [slider startTextAnimation];
  [slider setDelegate:self];
  [[self sliderPlaceHolder] addSubview:slider];
  [slider release];
  _slider = slider;
}

- (void)dealloc 
{
  [sliderPlaceHolder release];
  Block_release(_onSlideRightMostHandler);
  
  [super dealloc];
}

- (void) sliderDidSlideRightMost:(DSSlider *)sliderViewController
{
  [self onSlideRightMostHandler]();
}

- (void)setText:(NSString *)theText
{
  [_slider setText:theText];
}
@end
