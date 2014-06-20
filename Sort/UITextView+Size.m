//
//  UITextView+Size.m
//  DSLib
//
//  Created by Alexander Belyavskiy on 6/19/14.
//  Copyright (c) 2014 DS ltd. All rights reserved.
//

#import "UITextView+Size.h"

@implementation UITextView (Size)
- (void)updateTextViewSizeForText:(NSString *)text {
  CGRect textRect = [[self layoutManager] usedRectForTextContainer:[self textContainer]];
  CGFloat sizeAdjustment = [[self font] lineHeight] * [UIScreen mainScreen].scale;
  
  if (textRect.size.height >= self.frame.size.height - sizeAdjustment) {
    if ([text isEqualToString:@"\n"]) {
      [self setContentOffset:CGPointMake(self.contentOffset.x, self.contentOffset.y + sizeAdjustment+4)];
    }
  }
}
@end
