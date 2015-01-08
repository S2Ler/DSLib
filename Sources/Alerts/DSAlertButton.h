
@import Foundation;
#import "DSAlertsSupportCode.h"
#import "DSConstants.h"

@interface DSAlertButton: NSObject

@property (nonatomic, strong, readonly) NSString *title;

+ (instancetype)buttonWithTitle:(NSString *)theTitle
                         target:(id)theTarget
                         action:(SEL)theAction;

+ (instancetype)buttonWithTitle:(NSString *)theTitle
                invocationBlock:(ds_action_block_t)theBlock;

- (void)invoke;
@end

@interface DSAlertButton (FactoryMethods)
+ (instancetype)cancelButton;
+ (instancetype)cancelButtonWithBlock:(ds_action_block_t)block;
+ (instancetype)NOButton;
+ (instancetype)OKButton;
@end
