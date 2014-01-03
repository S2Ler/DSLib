//
//  DSTableViewController.h
//  DSLib
//
//  Created by Alexander Belyavskiy on 9/24/13.
//  Copyright (c) 2013 DS ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DSKeyboardControllerDelegate.h"
@class DSFieldValidationController;

@interface DSTableViewController : UITableViewController<DSKeyboardControllerDelegate>
@property (nonatomic, strong) NSIndexPath *indexPathForFirstResponderCell;
- (IBAction)resignActive:(id)sender;

- (DSFieldValidationController *)validationController;
@end
