//
//  DSViewsStackDataSource.h
//  DSLib
//
//  Created by Alexander Belyavskiy on 3/25/14.
//  Copyright (c) 2014 DS ltd. All rights reserved.
//

@import Foundation;

@protocol DSViewsStackDataSource <NSObject>
- (NSUInteger)numberOfViewsInViewsStack:(DSViewsStack *)viewsStack;
- (UIView *)viewsStack:(DSViewsStack *)viewsStack viewForIndex:(NSUInteger)viewIndex;
- (BOOL)viewStack:(DSViewsStack *)viewsStack isView:(UIView *)view1 equalToView:(UIView *)view2;
@end
