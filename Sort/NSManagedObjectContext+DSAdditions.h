//
//  NSManagedObjectContext+DSAdditions.h
//  DSLib
//
//  Created by Alexander Belyavskiy on 3/15/14.
//  Copyright (c) 2014 DS ltd. All rights reserved.
//

#import <CoreData/CoreData.h>

@interface NSManagedObjectContext (DSAdditions)
- (NSManagedObject *)objectWithURI:(NSURL *)uri;
@end
