
#import "PGAlertContentView.h"
#import "PGAlertMessageContentView.h"

@interface PGAlertActionContentView : PGAlertMessageContentView
/** Designated Init
 \param theAction should have target and action set. 
 */

@property (nonatomic, retain) UIButton *actionButton;

- (id)initWithTitle:(NSString *)theTitle
            message:(NSString *)theMessage
    foregroundColor:(UIColor *)theForegroundColor
    backgroundColor:(UIColor *)theBackgroundColor
             action:(NSInvocation *)theAction
        actionImage:(UIImage *)theActionImage;
@end
