
@import Foundation;
@import UIKit;
#import "DSConstants.h"

@interface DSBlockButton: UIButton
- (void)setActionBlock:(ds_action_block_t)actionBlock;
- (ds_action_block_t)actionBlock;

@end
