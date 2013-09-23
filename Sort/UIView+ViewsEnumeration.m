//
//  UIView+ViewsEnumeration.m
//  uPrintX
//
//  Created by Alexander Belyavskiy on 7/23/13.
//  Copyright (c) 2013 InGenius Labs. All rights reserved.
//

#import "UIView+ViewsEnumeration.h"

@implementation UIView (ViewsEnumeration)
- (void)enumerateViewsUsingBlock:(void(^)(UIView *view))block
{
    for (UIView *subView in [self subviews]) {
        block(subView);
        [subView enumerateViewsUsingBlock:block];
    }
}
@end
