
#import "PGAlertContentView.h"

@interface PGAlertMessageContentView : PGAlertContentView

@property (nonatomic, retain) UILabel *titleLabel;
@property (nonatomic, retain) UILabel *messageLabel;

/** Designated Init
 */
- (id)initWithTitle:(NSString *)theTitle
            message:(NSString *)theMessage
    foregroundColor:(UIColor *)theForegroundColor
    backgroundColor:(UIColor *)theBackgroundColor;
@end
