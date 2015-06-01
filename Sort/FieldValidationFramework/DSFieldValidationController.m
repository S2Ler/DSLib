
#pragma mark - include
#import "DSFieldValidationController.h"
#import "DSFieldValidationControllerDelegate.h"
#import "DSTextField.h"
#import "DSFieldValidationCriterion.h"
#import "DSFieldValidationCriteria.h"

#pragma mark - private
@interface DSFieldValidationController ()<UITextFieldDelegate>
@property (nonatomic, strong) NSMutableArray *fields;
@property (nonatomic, weak) DSTextField *focusedTextField;
@property (nonatomic, weak) UIViewController *parentViewController;
@end

@implementation DSFieldValidationController

#pragma mark - initialization
- (id)initWithDelegate:(id<DSFieldValidationControllerDelegate>)delegate
  parentViewController:(UIViewController *)parentViewController
{
  self = [super init];
  if (self) {
    _delegate = delegate;
    _fields = [NSMutableArray array];
    _parentViewController = parentViewController;
  }
  return self;
}

- (id)init
{
  return [self initWithDelegate:nil parentViewController:nil];
}

- (void)resignAllFields
{
  [[self fields] enumerateObjectsUsingBlock:^(DSTextField *field, NSUInteger idx, BOOL *stop) {
    [field resignFirstResponder];
  }];
}

- (void)addField:(DSTextField *)field criteria:(DSFieldValidationCriteria *)criteria
{
  NSAssert([field isKindOfClass:[DSTextField class]], @"Wrong field class: %@. It should be DSTextField", nil);

  __weak __block DSFieldValidationController *weakSelf = self;
  
  if (![[self fields] containsObject:field]) {
    [field setValidationCriteria:criteria];
    [[self fields] addObject:field];
    [field setDelegate:self];
    [field addTarget:self action:@selector(fieldChanged:) forControlEvents:UIControlEventEditingChanged];
    [field setDiscriptionButtonPressedHandler:^{
      [weakSelf resignAllFields];
    }];
    field.parentViewController = self.parentViewController;
  }
  else {
    DSFieldValidationCriteria *currentCriteria = field.validationCriteria;
    field.validationCriteria = [currentCriteria newMergedCopyWith:criteria];
  }
}

#pragma mark - validation
- (BOOL)validateAllFields
{
  [[self fields] enumerateObjectsUsingBlock:^(DSTextField *field, NSUInteger idx, BOOL *stop)
  {
    [self validateField:field];
  }];
  [self update_allFieldsPassedValidation_property];
  return [self allFieldsPassedValidation];
}

- (void)validateField:(DSTextField *)field
{
  NSArray *nonPassedCriteria = [self nonPassedCriteriaInField:field];
  if ([nonPassedCriteria count] > 0) {
    NSArray *nonPassedCriteriaDescriptions
    = [nonPassedCriteria valueForKeyPath:@"@unionOfObjects.criterionDescription"];
    [field setValidationFailedWithDescriptions:nonPassedCriteriaDescriptions];
  }
  else {
    [field setValidationPassedState];
  }
  [field setShouldValidateOnTextChange:YES];
}

- (NSArray *)nonPassedCriteriaInField:(DSTextField *)field
{
  DSFieldValidationCriteria *criteria = [field validationCriteria];

  NSArray *nonPassedCriteria = [criteria validateAgainstObject:[field text]];
  return nonPassedCriteria;
}

- (void)update_allFieldsPassedValidation_property
{
  __block BOOL allFieldsPassedValidation = YES;
  [[self fields] enumerateObjectsUsingBlock:^(DSTextField *field, NSUInteger idx, BOOL *stop)
  {
    if ([[self nonPassedCriteriaInField:field] count] > 0) {
      allFieldsPassedValidation = NO;
      *stop = YES;
    }
  }];
  [self setAllFieldsPassedValidation:allFieldsPassedValidation];
}

- (void)resetValidateOnTextChangeFlag
{
  for (DSTextField *field in [self fields]) {
    [field setShouldValidateOnTextChange:NO];
  }
}

- (void)setAllFieldsPassedValidation:(BOOL)allFieldsPassedValidation
{
  if (_allFieldsPassedValidation != allFieldsPassedValidation) {
    _allFieldsPassedValidation = allFieldsPassedValidation;
    [[self delegate] fieldValidationController:self allFieldsValidationChangedTo:allFieldsPassedValidation];
  }
}

#pragma mark - UITextFieldDelegateForwarding
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
  [self setFocusedTextField:(DSTextField *)textField];
  if ([[self delegate] respondsToSelector:@selector(textFieldShouldBeginEditing:)]) {
    return [[self delegate] textFieldShouldBeginEditing:textField];
  }
  else {
    return YES;
  }
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
  if ([[self delegate] respondsToSelector:@selector(textFieldDidBeginEditing:)]) {
    [[self delegate] textFieldDidBeginEditing:textField];
  }
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
  DSTextField *dsTextField = (DSTextField *)textField;
  [self validateField:dsTextField];
  [dsTextField setShouldValidateOnTextChange:YES];
  [self update_allFieldsPassedValidation_property];

  if ([[self delegate] respondsToSelector:@selector(textFieldShouldEndEditing:)]) {
    return [[self delegate] textFieldShouldEndEditing:textField];
  }
  else {
    return YES;
  }
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
  [self setFocusedTextField:nil];

  if ([[self delegate] respondsToSelector:@selector(textFieldDidEndEditing:)]) {
    [[self delegate] textFieldDidEndEditing:textField];
  }
}

- (BOOL)            textField:(UITextField *)textField
shouldChangeCharactersInRange:(NSRange)range
            replacementString:(NSString *)string
{
  DSTextField *dsTextField = (DSTextField *)textField;
  if ([dsTextField shouldValidateOnTextChange]) {
    [self validateField:dsTextField];
  }

  if ([[self delegate] respondsToSelector:@selector(textField:shouldChangeCharactersInRange:replacementString:)]) {
    return [[self delegate] textField:textField
        shouldChangeCharactersInRange:range
                    replacementString:string];
  }
  else {
    return YES;
  }
}

- (BOOL)textFieldShouldClear:(UITextField *)textField
{
  if ([[self delegate] respondsToSelector:@selector(textFieldShouldClear:)]) {
    return [[self delegate] textFieldShouldClear:textField];
  }

  return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
  if ([[self delegate] respondsToSelector:@selector(textFieldShouldReturn:)]) {
    return [[self delegate] textFieldShouldReturn:textField];
  }
  
  return YES;
}

- (void)fieldChanged:(DSTextField *)field
{
  if ([field shouldValidateOnTextChange]) {
    [self validateField:field];
  }
}
@end
