
#pragma mark - include
#import <CoreGraphics/CoreGraphics.h>
#import "DSTextField.h"
#import "DSFieldValidationCriterionDescription.h"
#import "FDPopoverBackgroundView.h"
#import "DSCriterionDescriptionViewController.h"
#import "DSCFunctions.h"
#import "DSMacros.h"

#define SHOW_DESCRIPTION_BUTTON_GAG 333

@interface DSTextFieldErrorButton: UIButton
@property (nonatomic, assign) CGPoint extendTouchArea;
@end

@implementation DSTextFieldErrorButton

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event
{
  if (CGPointEqualToPoint(self.extendTouchArea, CGPointZero)) {
    return [super pointInside:point withEvent:event];
  }
  else {
    CGRect bounds = self.bounds;
    CGRect touchArea = CGRectInset(bounds, -self.extendTouchArea.x, -self.extendTouchArea.y);
    return CGRectContainsPoint(touchArea, point);
  }
}

@end

#pragma mark - private
@interface DSTextField()<UIPopoverPresentationControllerDelegate>
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

- (UIImage *)validationFailedSelectedImage
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
  BOOL rightViewUpdated = false;
  
  if ([criterionDescriptions count] > 0) {
    if (self.rightView.tag != SHOW_DESCRIPTION_BUTTON_GAG) {
      DSTextFieldErrorButton *showDescriptionButton = [DSTextFieldErrorButton buttonWithType:UIButtonTypeCustom];
      showDescriptionButton.extendTouchArea = CGPointMake(20, 20);
      showDescriptionButton.tag = SHOW_DESCRIPTION_BUTTON_GAG;
      [showDescriptionButton addTarget:self
                                action:@selector(showDescriptionButtonPressed)
                      forControlEvents:UIControlEventTouchUpInside];
      [showDescriptionButton setImage:[self validationFailedImage] forState:UIControlStateNormal];
      [showDescriptionButton setImage:[self validationFailedSelectedImage] forState:UIControlStateSelected];
      
      CGRect showDescriptionButtonFrame = CGRectZero;
      showDescriptionButtonFrame.size = [[self validationFailedImage] size];
      [showDescriptionButton setFrame:showDescriptionButtonFrame];
      
      rightView = showDescriptionButton;
      rightViewUpdated = true;
    }
  }
  else {
    rightView = [[UIImageView alloc] initWithImage:[self validationFailedImage]];
    rightViewUpdated = true;
  }
  if (rightViewUpdated) {
    [self setRightView:rightView];
  }
  [self validationFailedStateDidSet];
}

- (void)setValidationPassedState
{
  self.isValidationPassed = true;
  [self setRightView:nil];
  [self validationPassedStateDidSet];
}

- (UIButton *)rightMenuButton
{
  if ([self.rightView isKindOfClass:[UIButton class]]) {
    return (UIButton *)self.rightView;
  }
  else {
    return nil;
  }
}

- (void)showDescriptionButtonPressed
{
  if ([self discriptionButtonPressedHandler]) {
    [self discriptionButtonPressedHandler]();
  }
  
  Class descriptionViewControllerClass = NSClassFromString(DSCriterionDescriptionViewController_ClassName);
  NSAssert(descriptionViewControllerClass, @"Nil description class");
  NSAssert([descriptionViewControllerClass isSubclassOfClass:[DSCriterionDescriptionViewController class]],
           @"description view controller should be subclass of DSCriterionDescriptionViewController");
  
  DSCriterionDescriptionViewController *descriptionViewController= [[descriptionViewControllerClass alloc] init];
  descriptionViewController.modalPresentationStyle = UIModalPresentationPopover;
  UIPopoverPresentationController *popover =  descriptionViewController.popoverPresentationController;
  popover.sourceView = self.parentViewController.view;
  popover.sourceRect = CGRectInset([self.parentViewController.view convertRect:self.rightView.frame fromView:self.rightView.superview], 0, -7);
  popover.backgroundColor = descriptionViewController.view.backgroundColor;
  popover.delegate = self;
  popover.popoverBackgroundViewClass = [FDPopoverBackgroundView class];
  popover.permittedArrowDirections = UIPopoverArrowDirectionDown;
  [[self rightMenuButton] setSelected:true];
  
  [self.parentViewController presentViewController:descriptionViewController animated:true completion:nil];

  [descriptionViewController setCriterionDescriptions:[self validationFailedDescriptions]];
}

#pragma mark - UIPopoverPresentationControllerDelegate
- (void)popoverPresentationController:(UIPopoverPresentationController *)popoverPresentationController
          willRepositionPopoverToRect:(inout CGRect *)rect
                               inView:(inout UIView **)view
{
  *rect = [self.rightView.window convertRect:self.rightView.frame fromView:self.rightView.superview];
}

- (void)popoverPresentationControllerDidDismissPopover:(UIPopoverPresentationController *)popoverPresentationController
{
  [[self rightMenuButton] setSelected:false];
}

@end
