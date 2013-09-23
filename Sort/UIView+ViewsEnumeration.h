//
//  UIView+ViewsEnumeration.h
//  uPrintX
//
//  Created by Alexander Belyavskiy on 7/23/13.
//  Copyright (c) 2013 InGenius Labs. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (ViewsEnumeration)
- (void)enumerateViewsUsingBlock:(void(^)(UIView *view))block;
@end
