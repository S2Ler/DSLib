//
//  UIView+Subviews.h
//  FlipDrive
//
//  Created by Alexander Belyavskiy on 10/16/11.
//  Copyright (c) 2011 FlipDrive.com. All rights reserved.
//

typedef void (^proccedView_block_t)(UIView *theView);

@interface UIView (Subviews)
/** NOTE: Recursive function, so isn't designed for large view hierarchy */
- (void)enumerateSubviewsUsingBlock:(proccedView_block_t)theBlock;
@end
