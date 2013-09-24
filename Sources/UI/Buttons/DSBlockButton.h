
#import <Foundation/Foundation.h>
#import "DSAlertsSupportCode.h"

@interface DSBlockButton: UIButton
@property (nonatomic, copy) ds_action_block_t actionBlock;
@end
