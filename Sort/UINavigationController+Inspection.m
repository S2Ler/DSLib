//
//  UINavigationController+Inspection.m
//  DSLib
//
//  Created by Alexander Belyavskiy on 6/14/14.
//  Copyright (c) 2014 DS ltd. All rights reserved.
//

#import "UINavigationController+Inspection.h"

@implementation UINavigationController (Inspection)
- (UIViewController *)findViewControllerPassingText:(BOOL(^)(UIViewController *))testPassedOn
{
  NSArray *viewControllers = [self viewControllers];
  for (UIViewController *viewController in [viewControllers reverseObjectEnumerator]) {
    if (testPassedOn(viewController)) {
      return viewController;
    }
  }
  
  return nil;
}

- (void)deepPopToViewController:(UIViewController *)viewController
{
  UIViewController *visibleViewController = [self topVisibleViewController];
  
  while (visibleViewController) {
    if (visibleViewController == viewController) {
      visibleViewController = nil;
    }
    else if ([visibleViewController navigationController] == self ||
             visibleViewController == self) {
      [self popToViewController:viewController animated:NO];
      visibleViewController = nil;
    }
    else if ([visibleViewController presentingViewController]) {
      UIViewController *presentingViewController = [visibleViewController presentingViewController];
      [visibleViewController dismissViewControllerAnimated:NO completion:nil];
      visibleViewController = presentingViewController;
    }
  }
}

- (UIViewController *)topVisibleViewController
{
  UIViewController *visibleViewController = nil;
  UIViewController *nextViewController = self;
  
  while (nextViewController != nil) {
    if ([nextViewController isKindOfClass:[UINavigationController class]]) {
      nextViewController = [(UINavigationController *)nextViewController visibleViewController];
    }
    else if ([nextViewController presentedViewController]) {
      nextViewController = [nextViewController presentedViewController];
    }
    else {
      nextViewController = nil;
    }
    
    if (nextViewController) {
      visibleViewController = nextViewController;
    }
  }
  
  return visibleViewController;
}
@end
