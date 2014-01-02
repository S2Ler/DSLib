//
//  IRFieldsValidationViewController.h
//  Inspection Reporting
//
//  Created by Alex on 06/11/2013.
//  Copyright (c) 2013 InGenius Labs. All rights reserved.
//

#import <DSLib/DSFieldValidationFramework.h>



@interface DSFieldsValidationViewController :
#ifdef DSFieldsValidationViewControllerSuperclass
DSFieldsValidationViewControllerSuperclass<DSFieldValidationControllerDelegate>
#else
UIViewController<DSFieldValidationControllerDelegate>
#endif

@property (nonatomic, strong, readonly) DSFieldValidationController *validationController;

- (void)validateField:(DSTextField *)field;
- (BOOL)validateAllFields;
@end

@interface DSFieldsValidationViewController(Callbacks)
- (void)allFieldsPassedValidationChanged:(BOOL)allFieldsPassedValidation;
- (BOOL)backButtonPressedAllowGoBack;
@end
