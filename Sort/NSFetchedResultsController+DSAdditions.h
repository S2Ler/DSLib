//
//  NSFetchedResultsController+DSAdditions.h
//  DSLib
//
//  Created by Alexander Belyavskiy on 3/20/14.
//  Copyright (c) 2014 DS ltd. All rights reserved.
//

#import <CoreData/CoreData.h>

@interface NSFetchedResultsController (DSAdditions)
- (NSArray *)objectsAtIndexPaths:(NSArray *)indexPaths;
@end
