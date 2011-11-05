
#import <UIKit/UIKit.h>

/** Background for the AlertView or Skin in other words */
@interface PGAlertSkinView : UIImageView

- (CGRect)contentViewFrame;

/** Designated Init.
 Bounds of the PGAlertSkinView will be set from theImageSize.
 \param theImageContentFrame frame inside view where contentView could be placed.
 */
- (id)initWithImage:(UIImage *)theImage
   contentViewFrame:(CGRect)theContentViewFrame;

/** imageContentFrame will be updated accordingly */
- (void)setFrame:(CGRect)frame;
@end
