
#pragma mark - include
#import <CoreGraphics/CoreGraphics.h>
#import "DSTextField.h"
#import "DSFieldValidationCriterionDescription.h"
#import "DSCriterionDescriptionViewController.h"
#import "DSFieldValidationCriterion.h"
#import "DSCFunctions.h"
#import "DSMacros.h"
#import "WYPopoverController.h"

#pragma mark - private
@interface DSTextField()
@property (nonatomic, strong) WYPopoverController *popoverController;
@property (nonatomic, strong) NSArray *validationFailedDescriptions;
@property (nonatomic, assign) BOOL isValidationPassed;
@end

@implementation DSTextField
- (void)validationFailedStateDidSet
{
  //
}

- (void)validationPassedStateDidSet
{
  //
}


- (UIImage *)validationFailedImage
{
  ASSERT_ABSTRACT_METHOD;
  return nil;
}

- (void)setValidationFailedWithDescriptions:(NSArray *)criterionDescriptions
{
  self.isValidationPassed = false;
  [self setValidationFailedDescriptions:criterionDescriptions];

  [self setRightViewMode:UITextFieldViewModeAlways];
  UIView *rightView = nil;
  if ([criterionDescriptions count] > 0) {
    UIButton *showDescriptionButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [showDescriptionButton addTarget:self
                              action:@selector(showDescriptionButtonPressed)
                    forControlEvents:UIControlEventTouchUpInside];
    [showDescriptionButton setImage:[self validationFailedImage] forState:UIControlStateNormal];

    CGRect showDescriptionButtonFrame = CGRectZero;
    showDescriptionButtonFrame.size = [[self validationFailedImage] size];
    [showDescriptionButton setFrame:showDescriptionButtonFrame];

    rightView = showDescriptionButton;
  }
  else {
    rightView = [[UIImageView alloc] initWithImage:[self validationFailedImage]];
  }
  [self setRightView:rightView];
  [self validationFailedStateDidSet];
}

- (void)setValidationPassedState
{
  self.isValidationPassed = true;
  [self setRightView:nil];
  [self validationPassedStateDidSet];
}

- (BOOL)isPassesCriterion:(DSFieldValidationCriterion *)criterion
{
  return [criterion validateWithObject:[self text]];
}


- (void)showDescriptionButtonPressed
{
  if ([self discriptionButtonPressedHandler]) {
    [self discriptionButtonPressedHandler]();
  }
  
  Class descriptionViewControllerClass = NSClassFromString(DSCriterionDescriptionViewController_ClassName);
  NSAssert(descriptionViewControllerClass, @"Nil description class");
  NSAssert([descriptionViewControllerClass isSubclassOfClass:[DSCriterionDescriptionViewController class]], @"description view controller should be subclass of DSCriterionDescriptionViewController");
  
  DSCriterionDescriptionViewController *descriptionViewController= [[descriptionViewControllerClass alloc] init];

  //TODO: Get rid of WEPopoverAndWrite something my own
  
  [WYPopoverController setDefaultTheme:[WYPopoverTheme theme]];
  WYPopoverBackgroundView *popoverAppearance = [WYPopoverBackgroundView appearance];
  UIColor *greenColor = [UIColor darkGrayColor];
  [popoverAppearance setFillTopColor:greenColor];
  [popoverAppearance setFillBottomColor:greenColor];
  [popoverAppearance setOuterStrokeColor:greenColor];
  [popoverAppearance setInnerStrokeColor:greenColor];
  
  WYPopoverController *popoverController = [[WYPopoverController alloc] initWithContentViewController:descriptionViewController];
  
  CGRect popoverFrame = self.rightView.frame;
  
  [popoverController presentPopoverFromRect:popoverFrame
                                     inView:[self rightView].superview
                   permittedArrowDirections:WYPopoverArrowDirectionAny
                                   animated:YES];
  [descriptionViewController setCriterionDescriptions:[self validationFailedDescriptions]];
  __block __weak DSTextField *weakSelf = self;
  [popoverController setDismissCompletionBlock:^(WYPopoverController *dismissedController) {
    [weakSelf setPopoverController:nil];
  }];

  [self setPopoverController:popoverController];
}

@end
