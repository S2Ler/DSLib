
#import <UIKit/UIKit.h>

#import "DSCheckButtonProtocol.h"

@interface UISwitch (DSCheckButton)
- (BOOL)isChecked;
- (void)setChecked:(BOOL)theFlag;

/** Return self instance which conforms to DSCheckButtonProtocol protocol */
- (id<DSCheckButtonProtocol>)checkButtonProtocol;
@end
