
@import Foundation;
@import UIKit;
#import "DSConstants.h"

@interface DSBlockBarButtonItem: UIBarButtonItem
- (id)initWithBarButtonSystemItem:(UIBarButtonSystemItem)systemItem;


@property (nonatomic, strong) ds_action_block_t actionBlock;
@end
