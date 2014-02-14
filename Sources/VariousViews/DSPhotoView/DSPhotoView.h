
#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@protocol DSPhotoViewDelegate;

@interface DSPhotoView : UIScrollView <UIScrollViewDelegate> 

- (void)killActivityIndicator;

// inits this view to have a button over the image
- (id)initWithFrame:(CGRect)frame target:(id)target action:(SEL)action;

- (void)resetZoom;

@property (nonatomic, weak) NSObject <DSPhotoViewDelegate> *photoDelegate;
@property (nonatomic, readonly) UIImageView *imageView;
@property (nonatomic, readonly) UIButton *button;
@property (nonatomic, readonly) UIActivityIndicatorView *activity;

@end



@protocol DSPhotoViewDelegate

// indicates single touch and allows controller repsond and go toggle fullscreen
- (void)didTapPhotoView:(DSPhotoView*)photoView;

@end

