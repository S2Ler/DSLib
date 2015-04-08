
@import Foundation;
@import UIKit;

@class DSFieldValidationCriterionDescription;
@class DSFieldValidationCriterion;


@interface DSTextField: UITextField

@property (nonatomic, strong) NSArray *validationCriteria;
@property (nonatomic, assign) BOOL shouldValidateOnTextChange;
@property (nonatomic, copy) dispatch_block_t discriptionButtonPressedHandler;
@property (nonatomic, assign, readonly) BOOL isValidationPassed;
@property (nonatomic, weak) UIViewController *parentViewController;

- (void)setValidationFailedWithDescriptions:(NSArray *)criterionDescriptions;
- (void)setValidationPassedState;

- (BOOL)isPassesCriterion:(DSFieldValidationCriterion *)criterion;

@end

@interface DSTextField(Callbacks)
- (void)validationFailedStateDidSet;
- (void)validationPassedStateDidSet;
@end

@interface  DSTextField(Abstract)
- (UIImage *)validationFailedImage;
@end
