
#pragma mark - include
#import "DSUIAlertView.h"
#import "DSAlertViewDelegate.h"

#pragma mark - private
@interface DSUIAlertView ()
@property (nonatomic, weak) id<DSAlertViewDelegate> alertDelegate;
@end

@implementation DSUIAlertView

- (id)initWithTitle:(NSString *)title
            message:(NSString *)message
           delegate:(id<DSAlertViewDelegate>)delegate
  cancelButtonTitle:(NSString *)cancelButtonTitle
  otherButtonTitles:(NSString *)otherButtonTitles, ...
{
  NSMutableArray *otherButtonTitlesArray = [NSMutableArray array];

  va_list buttonTitlesList;
  va_start(buttonTitlesList, otherButtonTitles);
  for (NSString *buttonTitle = otherButtonTitles;
      buttonTitle != nil;
      buttonTitle = va_arg(buttonTitlesList, NSString *))
  {
    [otherButtonTitlesArray addObject:buttonTitle];
  }

  return [self initWithTitle:title
                     message:message
                    delegate:delegate
           cancelButtonTitle:cancelButtonTitle
                 otherTitles:otherButtonTitlesArray];
}

- (id)initWithTitle:(NSString *)title
            message:(NSString *)message
           delegate:(id<DSAlertViewDelegate>)delegate
  cancelButtonTitle:(NSString *)cancelButtonTitle
        otherTitles:(NSArray *)otherButtonTitles
{
  self = [super initWithTitle:title
                      message:message
                     delegate:nil
            cancelButtonTitle:cancelButtonTitle
            otherButtonTitles:nil];

  if (self) {
    for (NSString *buttonTitle in otherButtonTitles) {
      [self addButtonWithTitle:buttonTitle];
    }
    
    [self setDelegate:delegate];
  }

  return self;
}

- (void)setDelegate:(id<DSAlertViewDelegate>)theDelegate
{
  [super setDelegate:self];
  [self setAlertDelegate:theDelegate];
}

- (void)show
{
  [super show];
}

- (void)dismissAnimated:(BOOL)animated
{
  [super dismissWithClickedButtonIndex:[self cancelButtonIndex] animated:YES];
}

- (BOOL)isCancelButtonAtIndex:(NSInteger)theButtonIndex
{
  return [self cancelButtonIndex] == theButtonIndex;
}

- (void)        alertView:(UIAlertView *)alertView
didDismissWithButtonIndex:(NSInteger)buttonIndex
{
  [[self alertDelegate] alertView:self didDismissWithButtonIndex:buttonIndex];
}


@end
