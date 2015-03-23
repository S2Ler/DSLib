//
//  DSTableViewController.m
//  DSLib
//
//  Created by Alexander Belyavskiy on 9/24/13.
//  Copyright (c) 2013 DS ltd. All rights reserved.
//

#import "DSTableViewController.h"
#import "DSKeyboardController.h"
#import <DSLibFramework/DSFieldValidationController.h>

@interface DSTableViewController () {
  DSFieldValidationController *_validationController;
}

@property (nonatomic, strong) DSKeyboardController *keyboardController;
@end

@implementation DSTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidAppear:(BOOL)animated
{
  [super viewDidAppear:animated];
    
  if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
    [self setKeyboardController:[[DSKeyboardController alloc] init]];
    [[self keyboardController] setDelegate:self];
  }
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [self setKeyboardController:nil];
}

- (IBAction)resignActive:(id)sender
{
  [sender resignFirstResponder];
}

- (void)setIndexPathForFirstResponderCell:(NSIndexPath *)indexPathForFirstResponderCell
{
  if (_indexPathForFirstResponderCell) {
    [[self tableView] scrollToRowAtIndexPath:indexPathForFirstResponderCell
                            atScrollPosition:UITableViewScrollPositionMiddle
                                    animated:YES];
  }
  
  _indexPathForFirstResponderCell = indexPathForFirstResponderCell;
}

#pragma mark - DSKeyboardControllerDelegate
- (void)    keyboardController:(DSKeyboardController *)keyboardController
keyboardWillShowWithFrameBegin:(CGRect)frameBegin
                      frameEnd:(CGRect)frameEnd
             animationDuration:(double)animationDuration
                animationCurve:(UIViewAnimationCurve)animationCurve
{
  const CGFloat keyboardHeight = frameEnd.size.height;
  
  [UIView animateWithDuration:animationDuration
                   animations:^
   {
     [UIView setAnimationCurve:animationCurve];
     [[self tableView] setContentInset:UIEdgeInsetsMake(0, 0, keyboardHeight, 0)];
   }];
}

- (void)   keyboardController:(DSKeyboardController *)keyboardController
keyboardDidShowWithFrameBegin:(CGRect)frameBegin
                     frameEnd:(CGRect)frameEnd
{
}

- (void)    keyboardController:(DSKeyboardController *)keyboardController
keyboardWillHideWithFrameBegin:(CGRect)frameBegin
                      frameEnd:(CGRect)frameEnd
             animationDuration:(double)animationDuration
                animationCurve:(UIViewAnimationCurve)animationCurve
{
    [UIView animateWithDuration:animationDuration
                     animations:^
                     {
                         [UIView setAnimationCurve:animationCurve];
                       [[self tableView] setContentInset:UIEdgeInsetsMake(0, 0, 0, 0)];
                     }];
}

- (void)   keyboardController:(DSKeyboardController *)keyboardController
keyboardDidHideWithFrameBegin:(CGRect)frameBegin
                     frameEnd:(CGRect)frameEnd
{
  [self setIndexPathForFirstResponderCell:nil];
}

- (void)keyboardController:(DSKeyboardController *)keyboardController
       willChangeFrameFrom:(CGRect)frameBeing
                        to:(CGRect)frameEnd
{

}

- (void)keyboardController:(DSKeyboardController *)keyboardController
        didChangeFrameFrom:(CGRect)frameBeing
                        to:(CGRect)frameEnd
{

}

- (DSFieldValidationController *)validationController
{
  if (!_validationController) {
    _validationController = [[DSFieldValidationController alloc] init];
  }
  
  return _validationController;
}


@end
