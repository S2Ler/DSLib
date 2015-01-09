//
//  DSKeyboardController.h
//  DSLib
//
//  Created by Alexander Belyavskiy on 9/24/13.
//  Copyright (c) 2013 DS ltd. All rights reserved.
//

@import Foundation;
#import "DSKeyboardControllerDelegate.h"

#define DSKeyboardControllerDebug 0

@interface DSKeyboardController : NSObject
@property (nonatomic, weak) id<DSKeyboardControllerDelegate> delegate;

- (CGRect)convertRect:(CGRect)rect
               toView:(UIView *)view;
@end
