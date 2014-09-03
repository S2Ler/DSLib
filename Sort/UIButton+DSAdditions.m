//
//  UIButton+DSAdditions.m
//  DSLib
//
//  Created by Diejmon on 9/2/14.
//  Copyright (c) 2014 DS ltd. All rights reserved.
//

#import "UIButton+DSAdditions.h"

@implementation UIButton (DSAdditions)
- (void)setImageTextSpacing:(CGFloat)spacing imageLeftSpacing:(CGFloat)imageSpacing
{
  self.imageEdgeInsets = UIEdgeInsetsMake(0, imageSpacing, 0, spacing);
  self.titleEdgeInsets = UIEdgeInsetsMake(0, spacing+imageSpacing, 0, 0);
}

@end
