
#import <UIKit/UIKit.h>

@interface DSRotatingImageView : UIImageView
/** Number of Turnovers in second */
@property (nonatomic, assign) double rps;

- (void)startAnimating;
- (void)endAnimating;
@end
