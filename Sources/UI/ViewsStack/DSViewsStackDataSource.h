//
//  DSViewsStackDataSource.h
//  DSLib
//
//  Created by Alexander Belyavskiy on 3/25/14.
//  Copyright (c) 2014 DS ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol DSViewsStackDataSource <NSObject>
- (NSUInteger)numberOfViewsInViewsStack:(DSViewsStack *)viewsStack;
- (UIView *)viewsStack:(DSViewsStack *)viewsStack viewForIndex:(NSUInteger)viewIndex;
@end
