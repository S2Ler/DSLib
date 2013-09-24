//
//  DSTableViewController.m
//  DSLib
//
//  Created by Alexander Belyavskiy on 9/24/13.
//  Copyright (c) 2013 DS ltd. All rights reserved.
//

#import "DSTableViewController.h"
#import "DSKeyboardController.h"

@interface DSTableViewController ()
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
    [self setKeyboardController:[[DSKeyboardController alloc] init]];
    [[self keyboardController] setDelegate:self];
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
  _indexPathForFirstResponderCell = indexPathForFirstResponderCell;
  
  [[self tableView] scrollToRowAtIndexPath:indexPathForFirstResponderCell
                          atScrollPosition:UITableViewScrollPositionTop
                                  animated:YES];
}

#pragma mark - DSKeyboardControllerDelegate
- (void)    keyboardController:(DSKeyboardController *)keyboardController
keyboardWillShowWithFrameBegin:(CGRect)frameBegin
                      frameEnd:(CGRect)frameEnd
             animationDuration:(double)animationDuration
                animationCurve:(UIViewAnimationCurve)animationCurve
{
    const CGRect keyboardEndFrame = [keyboardController convertRect:frameEnd
                                                             toView:[self tableView]];
    const CGRect tableCurrentFrame = [[self tableView] frame];
    CGRect tableNewFrame = tableCurrentFrame;
    if (tableCurrentFrame.size.width > keyboardEndFrame.origin.y) {
        tableNewFrame.size.height = keyboardEndFrame.origin.y;
    }
    [UIView animateWithDuration:animationDuration
                     animations:^
                     {
                         [UIView setAnimationCurve:animationCurve];
                         [[self tableView] setFrame:tableNewFrame];
                     }];
}

- (void)   keyboardController:(DSKeyboardController *)keyboardController
keyboardDidShowWithFrameBegin:(CGRect)frameBegin
                     frameEnd:(CGRect)frameEnd
{
    if ([self indexPathForFirstResponderCell]) {
        [[self tableView] scrollToRowAtIndexPath:[self indexPathForFirstResponderCell]
                                atScrollPosition:UITableViewScrollPositionTop
                                        animated:YES];
    }
}

- (void)    keyboardController:(DSKeyboardController *)keyboardController
keyboardWillHideWithFrameBegin:(CGRect)frameBegin
                      frameEnd:(CGRect)frameEnd
             animationDuration:(double)animationDuration
                animationCurve:(UIViewAnimationCurve)animationCurve
{
    const CGRect keyboardEndFrame = [keyboardController convertRect:frameEnd
                                                             toView:[self tableView]];
    const CGRect tableCurrentFrame = [[self tableView] frame];
    CGRect tableNewFrame = tableCurrentFrame;
    tableNewFrame.size.height = keyboardEndFrame.origin.y;
    [UIView animateWithDuration:animationDuration
                     animations:^
                     {
                         [UIView setAnimationCurve:animationCurve];
                         [[self tableView] setFrame:tableNewFrame];
                     }];
}

- (void)   keyboardController:(DSKeyboardController *)keyboardController
keyboardDidHideWithFrameBegin:(CGRect)frameBegin
                     frameEnd:(CGRect)frameEnd
{

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


@end
