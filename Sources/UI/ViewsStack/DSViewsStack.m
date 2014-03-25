//
//  DSViewsStack.m
//  DSLib
//
//  Created by Alexander Belyavskiy on 3/25/14.
//  Copyright (c) 2014 DS ltd. All rights reserved.
//

#import "DSViewsStack.h"
#import "DSViewsStackDataSource.h"

@implementation DSViewsStack

- (NSUInteger)numberOfViews
{
  return [[self dataSource] numberOfViewsInViewsStack:self];
}

- (UIView *)viewForIndex:(NSUInteger)index
{
  return [[self dataSource] viewsStack:self viewForIndex:index];
}

@end
