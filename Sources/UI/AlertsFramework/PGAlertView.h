
#import <UIKit/UIKit.h>

#import "PGAlertContentView.h"
#import "PGAlertSkinView.h"

@interface PGAlertView : UIView
/** Designated init
 PGAlertView will have bounds the same as theRootView.
 theSkinView will be scaled to occupy entire theRootView
 theContentView will be placed somewhere inside theSkinView in proper location
 */
- (id)showInView:(UIView *)theRootView
     contentView:(PGAlertContentView *)theContentView
        animated:(BOOL)theAnimationFlag
            skin:(PGAlertSkinView *)theSkinView;

- (void)hideAnimated:(BOOL)theAnimationFlag;
- (void)showAnimated:(BOOL)theAnimationFlag;

@end
