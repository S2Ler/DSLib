
#import <UIKit/UIKit.h>
#import "DSCheckButtonProtocol.h"

@interface DSCheckButton : UIButton<DSCheckButtonProtocol>

- (void)setUncheckedImage:(UIImage *)theUncheckedImage
             checkedImage:(UIImage *)theCheckedImage;

@end
