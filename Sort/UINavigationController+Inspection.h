//
//  UINavigationController+Inspection.h
//  DSLib
//
//  Created by Alexander Belyavskiy on 6/14/14.
//  Copyright (c) 2014 DS ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UINavigationController (Inspection)
- (UIViewController *)findViewControllerPassingText:(BOOL(^)(UIViewController *))test;
- (void)deepPopToViewController:(UIViewController *)viewController;
- (UIViewController *)topVisibleViewController;
@end
