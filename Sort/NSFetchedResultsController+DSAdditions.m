//
//  NSFetchedResultsController+DSAdditions.m
//  DSLib
//
//  Created by Alexander Belyavskiy on 3/20/14.
//  Copyright (c) 2014 DS ltd. All rights reserved.
//

#import "NSFetchedResultsController+DSAdditions.h"

@implementation NSFetchedResultsController (DSAdditions)
- (NSArray *)objectsAtIndexPaths:(NSArray *)indexPaths
{
  NSMutableArray *objects = [NSMutableArray array];
  for (NSIndexPath *indexPath in indexPaths) {
    [objects addObject:[self objectAtIndexPath:indexPath]];
  }
  
  return [objects copy];
}
@end
