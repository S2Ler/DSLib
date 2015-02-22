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
#import "NSObject+DSAdditions.h"
#import "NSString+Encoding.h"
#import "NSString+Extras.h"

@interface DSAskForTextController ()<UIAlertViewDelegate>
@property (nonatomic, strong) NSMutableSet *alertViews;
@end

@implementation DSAskForTextController
+ (instancetype)shareInstance
{
  DEFINE_SHARED_INSTANCE_USING_BLOCK(^{
    return [[self alloc] init];
  });
}

- (id)init
{
  self = [super init];
  if (self) {
    _alertViews = [NSMutableSet set];
  }
  return self;
}

- (void)askForTextWithTitle:(NSString *)title
                   isSecure:(BOOL)secure
                placeholder:(NSString *)placeholder
                initialText:(NSString *)initialText
             withCompletion:(DSAskForTextControllerCompletion)completion
{
  [self askForTextWithTitle:title
                placeholder:placeholder
                initialText:initialText
                    options:secure ? DSAskForTextControllerOptionSecure : DSAskForTextControllerOptionNone
             withCompletion:completion];
}

- (void)askForTextWithTitle:(NSString *)title
                placeholder:(NSString *)placeholder
                initialText:(NSString *)initialText
                    options:(DSAskForTextControllerOptions)options
             withCompletion:(DSAskForTextControllerCompletion)completion
{
  [self askForTextWithTitle:title
                placeholder:placeholder
                initialText:initialText
                    options:options
          isTextValidTester:nil
             withCompletion:completion];
}

- (void)askForTextWithTitle:(NSString *)title
                placeholder:(NSString *)placeholder
                initialText:(NSString *)initialText
                    options:(DSAskForTextControllerOptions)options
          isTextValidTester:(BOOL(^)(NSString *))isTextValid
             withCompletion:(DSAskForTextControllerCompletion)completion
{
  DSAskForTextControllerConfig *config = [DSAskForTextControllerConfig config];
  config.options = options;
  config.isTextValidTester = isTextValid;
  config.completion = completion;
  
  [self askForTextWithTitle:title placeholder:placeholder initialText:initialText config:config];
}

- (void)askForTextWithTitle:(NSString *)title
                placeholder:(NSString *)placeholder
                initialText:(NSString *)initialText
                     config:(DSAskForTextControllerConfig *)config
{
  NSString *cancelButtonTitle = config.cancelButtonTitle;
  if (!cancelButtonTitle) {
    cancelButtonTitle = NSLocalizedString(@"Cancel", nil);
  }
  
  NSString *okButtonTitle = config.okButtonTitle;
  if (!okButtonTitle) {
    okButtonTitle = NSLocalizedString(@"OK", nil);
  }
  UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title ? title : @""
                                                      message:nil
                                                     delegate:self
                                            cancelButtonTitle:cancelButtonTitle
                                            otherButtonTitles:okButtonTitle, nil];
  
  NSMutableDictionary *userInfo = [alertView objectUserInfo];
  userInfo[@"completion"] = config.completion;
  userInfo[@"options"] = @(config.options);
  if (config.isTextValidTester) {
    userInfo[@"isTextValidTester"] = config.isTextValidTester;
  }
  
  if (config.options & DSAskForTextControllerOptionSecure) {
    [alertView setAlertViewStyle:UIAlertViewStyleSecureTextInput];
  }
  else {
    [alertView setAlertViewStyle:UIAlertViewStylePlainTextInput];
  }
  
  if ([placeholder length] > 0) {
    [[alertView textFieldAtIndex:0] setPlaceholder:placeholder];
  }
  
  [[alertView textFieldAtIndex:0] setText:initialText];
  
  [[self alertViews] addObject:alertView];
  [alertView show];
  
  NSAssert(!(config.options & DSAskForTextControllerOptionPlaceholderIsValidText) || ((config.options & DSAskForTextControllerOptionPlaceholderIsValidText) && [placeholder length] > 0), @"DSAskForTextControllerOptionPlaceholderIsValidText is only valid with non empty placeholder");
}

- (BOOL)alertViewShouldEnableFirstOtherButton:(UIAlertView *)alertView
{
  DSAskForTextControllerOptions options = [[[alertView objectUserInfo] objectForKey:@"options"] unsignedIntegerValue];
  BOOL (^isTextValid)(NSString *text) = [[alertView objectUserInfo] objectForKey:@"isTextValidTester"];
  
  NSString *const alertViewText = [[alertView textFieldAtIndex:0] text];
  NSString *const alertViewPlaceHolder = [[alertView textFieldAtIndex:0] placeholder];
  
  if (isTextValid && !isTextValid(alertViewText)) {
    return NO;
  }
  
  if ((options & DSAskForTextControllerOptionPlaceholderIsValidText)
      && [alertViewPlaceHolder length] > 0) {
    return YES;
  }
  
  return [alertViewText length] > 0;
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
  DSAskForTextControllerCompletion completion = [alertView objectUserInfo][@"completion"];
  DSAskForTextControllerOptions options = [[alertView objectUserInfo][@"options"] unsignedIntegerValue];
  
  if (buttonIndex == [alertView cancelButtonIndex]) {
    if (completion) {
      completion(NO, nil);
    }
  }
  else {
    if (completion) {
      NSString *text = [[alertView textFieldAtIndex:0] text];
      if (options & DSAskForTextControllerOptionTrimWhiteSpace) {
        text = [text trimWhiteSpaces];
      }
      
      if ([text length] == 0 && (options & DSAskForTextControllerOptionPlaceholderIsValidText)) {
        text = [[alertView textFieldAtIndex:0] placeholder];
      }
      
      if (options & DSAskForTextControllerOptionTrimWhiteSpace) {
        text = [text trimWhiteSpaces];
      }
      
      completion(YES, text);
    }
  }
  
  [[self alertViews] removeObject:alertView];
}
@end

@implementation DSAskForTextControllerConfig

+ (instancetype)config
{
  return [self new];
}

@end