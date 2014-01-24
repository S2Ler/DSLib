
#import <Foundation/Foundation.h>

@protocol DSFieldValidationControllerDelegate;
@class DSTextField;

@interface DSFieldValidationController: NSObject
@property (nonatomic, weak) id<DSFieldValidationControllerDelegate> delegate;
@property (nonatomic, assign) BOOL allFieldsPassedValidation;
@property (nonatomic, weak, readonly) DSTextField *focusedTextField;

- (id)initWithDelegate:(id<DSFieldValidationControllerDelegate>)delegate;

/** if field already added - nothing happens */
- (void)addField:(DSTextField *)field
        criteria:(NSArray *)criteria;

- (BOOL)validateAllFields;
- (void)validateField:(DSTextField *)field;

- (void)resetValidateOnTextChangeFlag;
@end
