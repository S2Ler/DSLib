//
//  DSAskForTextController.m
//  DSLib
//
//  Created by Alex on 12/11/2013.
//  Copyright (c) 2013 DS ltd. All rights reserved.
//

#pragma mark - include
#import "DSAskForTextController.h"
#import "DSMacros.h"

@interface DSAskForTextController ()<UIAlertViewDelegate>
@property (nonatomic, strong) UIAlertView *alertView;
@property (nonatomic, copy) DSAskForTextControllerCompletion completion;
@end

@implementation DSAskForTextController
+ (instancetype)shareInstance
{
  DEFINE_SHARED_INSTANCE_USING_BLOCK(^{
    return [[self alloc] init];
  });
}

- (void)askForTextWithTitle:(NSString *)title
                   isSecure:(BOOL)secure
                placeholder:(NSString *)placeholder
                initialText:(NSString *)initialText
             withCompletion:(DSAskForTextControllerCompletion)completion
{
  _completion = completion;
  
  UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title
                                                      message:nil
                                                     delegate:self
                                            cancelButtonTitle:NSLocalizedString(@"Cancel", nil)
                                            otherButtonTitles:NSLocalizedString(@"OK", nil), nil];
  if (secure) {
    [alertView setAlertViewStyle:UIAlertViewStyleSecureTextInput];
  }
  else {
    [alertView setAlertViewStyle:UIAlertViewStylePlainTextInput];
  }
  
  if ([placeholder length] > 0) {
    [[alertView textFieldAtIndex:0] setPlaceholder:placeholder];
  }
  
  [[alertView textFieldAtIndex:0] setText:initialText];
  
  [self setAlertView:alertView];
  [alertView show];
}

- (BOOL)alertViewShouldEnableFirstOtherButton:(UIAlertView *)alertView
{
  return [[[alertView textFieldAtIndex:0] text] length] > 0;
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
  if (buttonIndex == [alertView cancelButtonIndex]) {
    if ([self completion]) {
      [self completion](NO, nil);
    }
  }
  else {
    if ([self completion]) {
      [self completion](YES, [[alertView textFieldAtIndex:0] text]);
    }
  }
  [self setAlertView:nil];
  [self setCompletion:nil];
}
@end
