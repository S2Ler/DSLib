//
//  UIView+Subviews.m
//  FlipDrive
//
//  Created by Alexander Belyavskiy on 10/16/11.
//  Copyright (c) 2011 FlipDrive.com. All rights reserved.
//

#import "UIView+Subviews.h"

@implementation UIView (Subviews)
- (void)enumerateSubviewsUsingBlock:(proccedView_block_t)theBlock
{
  for (UIView *subview in [self subviews]) {
    theBlock(subview);
    [subview enumerateSubviewsUsingBlock:theBlock];
  }
}
@end
