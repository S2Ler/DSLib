
#import "DSAlertView.h"

@interface DSUIAlertView: UIAlertView<DSAlertView, UIAlertViewDelegate>

- (id)initWithTitle:(NSString *)title
            message:(NSString *)message
           delegate:(id<DSAlertViewDelegate>)delegate
  cancelButtonTitle:(NSString *)cancelButtonTitle
        otherTitles:(NSArray *)otherButtonTitles;

@end
