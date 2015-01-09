@import Foundation;

@class DSValueChooserViewController;

@protocol DSValueChooserViewControllerDelegate <NSObject>
/** \param theValue is from the values supplied in init method */
- (void)valueChooserViewController:(DSValueChooserViewController *)theController
                   didEndWithValue:(id)theValue;
- (void)valueChooserViewControllerDidCancel:(DSValueChooserViewController *)theController;
@end
