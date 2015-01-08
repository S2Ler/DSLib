
@import UIKit;

@class DSFieldValidationController;

@protocol DSFieldValidationControllerDelegate<NSObject, UITextFieldDelegate>
- (void)fieldValidationController:(DSFieldValidationController *)validationController
     allFieldsValidationChangedTo:(BOOL)allFieldsPassedValidation;
@end
