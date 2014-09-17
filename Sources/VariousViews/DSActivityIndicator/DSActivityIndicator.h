
#import <UIKit/UIKit.h>

@interface DSActivityIndicator : UIView {
	UIActivityIndicatorView *activityIndicator_;
	UIImageView *doneImageView_;
	BOOL isAnimating_;
}

- (id)initWithFrame:(CGRect)frame
              style:(UIActivityIndicatorViewStyle)aStyle NS_DESIGNATED_INITIALIZER;

- (void)setStopAnimatingImage:(UIImage *)anImage;

- (void)startAnimating;
- (void)stopAnimating;

@end
