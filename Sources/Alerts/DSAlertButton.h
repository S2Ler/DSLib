
#import <Foundation/Foundation.h>
#import "DSAlertsSupportCode.h"


@interface DSAlertButton: NSObject

@property (nonatomic, strong, readonly) NSString *title;

+ (id)buttonWithTitle:(NSString *)theTitle
               target:(id)theTarget
              action:(SEL)theAction;

+ (id)buttonWithTitle:(NSString *)theTitle
      invocationBlock:(ds_action_block_t)theBlock;

- (void)invoke;
@end

@interface DSAlertButton (FactoryMethods)
+ (id)cancelButton;
+ (id)NOButton;
+ (id)OKButton;
@end
