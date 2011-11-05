
#import <UIKit/UIKit.h>

@interface DSActivityIndicator : UIView {
	UIActivityIndicatorView *activityIndicator_;
	UIImageView *doneImageView_;
	BOOL isAnimating_;
}

//Designated initializer
- (id)initWithFrame:(CGRect)frame
              style:(UIActivityIndicatorViewStyle)aStyle;

- (void)setStopAnimatingImage:(UIImage *)anImage;

- (void)startAnimating;
- (void)stopAnimating;

@end
