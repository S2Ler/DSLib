//
//  IRFieldsValidationViewController.m
//  Inspection Reporting
//
//  Created by Alex on 06/11/2013.
//  Copyright (c) 2013 InGenius Labs. All rights reserved.
//

#import "DSFieldsValidationViewController.h"
#import <DSLib/NSString+Encoding.h>

@interface DSFieldsValidationViewController ()
{
  DSFieldValidationController *_validationController;
}

@end

@implementation DSFieldsValidationViewController

- (void)allFieldsPassedValidationChanged:(BOOL)allFieldsPassedValidation
{
  //
}


- (void)viewDidLoad
{
  [super viewDidLoad];
}

- (void)dealloc
{
  [_validationController removeObserver:self forKeyPath:@"allFieldsPassedValidation"];
}

- (void)viewDidUnload
{
  [_validationController removeObserver:self forKeyPath:@"allFieldsPassedValidation"];
  _validationController = nil;
  [super viewDidUnload];
}

- (DSFieldValidationController *)validationController
{
  if (!_validationController) {
    _validationController = [[DSFieldValidationController alloc] initWithDelegate:self];
    [_validationController addObserver:self
                            forKeyPath:@"allFieldsPassedValidation"
                               options:NSKeyValueObservingOptionNew
                               context:(__bridge void *)self];
  }
  
  return _validationController;
}

- (void)validateField:(DSTextField *)field
{
  [[self validationController] validateField:field];
}

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context
{
  if (context == (__bridge void *)self) {
    if ([keyPath isEqualToString:@"allFieldsPassedValidation"]) {
      [self allFieldsPassedValidationChanged:[[change valueForKey:NSKeyValueChangeNewKey] boolValue]];
    }
  }
  else {
    [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
  }
}

- (BOOL)validateAllFields
{
  [[self validationController] validateAllFields];
  return [[self validationController] allFieldsPassedValidation];
}


@end
