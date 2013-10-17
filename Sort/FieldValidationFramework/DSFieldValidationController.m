
#pragma mark - include
#import "DSFieldValidationController.h"
#import "DSFieldValidationControllerDelegate.h"
#import "DSTextField.h"
#import "DSFieldValidationCriterion.h"

#pragma mark - private
@interface DSFieldValidationController ()<UITextFieldDelegate>
@property (nonatomic, strong) NSMutableArray *fields;
@property (nonatomic, weak) DSTextField *focusedTextField;

@end

@implementation DSFieldValidationController

#pragma mark - initialization
- (id)initWithDelegate:(id<DSFieldValidationControllerDelegate>)delegate
{
  self = [super init];
  if (self) {
    _delegate = delegate;
    _fields = [NSMutableArray array];
  }
  return self;
}

- (void)resignAllFields
{
  [[self fields] enumerateObjectsUsingBlock:^(DSTextField *field, NSUInteger idx, BOOL *stop) {
    [field resignFirstResponder];
  }];
}

- (void)addField:(DSTextField *)field criteria:(NSArray *)criteria
{
  NSAssert([field isKindOfClass:[DSTextField class]], @"Wrong field class: %@. It should be DSTextField", nil);

  __weak __block DSFieldValidationController *weakSelf = self;
  
  if (![[self fields] containsObject:field]) {
    [field setValidationCriteria:criteria];
    [[self fields] addObject:field];
    [field setDelegate:self];
    [field addTarget:self
              action:@selector(fieldChanged:)
    forControlEvents:UIControlEventEditingChanged];
    [field setDiscriptionButtonPressedHandler:^{
      [weakSelf resignAllFields];
    }];
  }
}

#pragma mark - validation
- (void)validateAllFields
{
  [[self fields] enumerateObjectsUsingBlock:^(DSTextField *field, NSUInteger idx, BOOL *stop)
  {
    [self validateField:field];
  }];
  [self update_allFieldsPassedValidation_property];
}

- (void)validateField:(DSTextField *)field
{
  NSArray *nonPassedCriteria = [self nonPassedCriteriaInField:field];
  if ([nonPassedCriteria count] > 0) {
    NSArray *nonPassedCriteriaDescriptions = [nonPassedCriteria valueForKeyPath:@"@unionOfObjects.criterionDescription"];
    [field setValidationFailedWithDescriptions:nonPassedCriteriaDescriptions];
  }
  else {
    [field setValidationPassedState];
  }
  [field setShouldValidateOnTextChange:YES];
}

- (NSArray *)nonPassedCriteriaInField:(DSTextField *)field
{
  NSArray *criteria = [field validationCriteria];

  NSMutableArray *nonPassedCriteria = [NSMutableArray array];
  for (DSFieldValidationCriterion *criterion in criteria) {
    BOOL isPassesCriterion = [field isPassesCriterion:criterion];
    if (!isPassesCriterion) {
      [nonPassedCriteria addObject:criterion];
    }
  }

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
