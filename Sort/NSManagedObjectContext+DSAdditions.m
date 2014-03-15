//
//  NSManagedObjectContext+DSAdditions.m
//  DSLib
//
//  Created by Alexander Belyavskiy on 3/15/14.
//  Copyright (c) 2014 DS ltd. All rights reserved.
//

#import "NSManagedObjectContext+DSAdditions.h"

@implementation NSManagedObjectContext (DSAdditions)
- (NSManagedObject *)objectWithURI:(NSURL *)uri
{
  NSManagedObjectID *objectID = [[self persistentStoreCoordinator] managedObjectIDForURIRepresentation:uri];
  
  if (!objectID)
  {
    return nil;
  }
  
  NSManagedObject *objectForID = [self objectWithID:objectID];
  if (![objectForID isFault])
  {
    return objectForID;
  }
  
  NSFetchRequest *request = [[NSFetchRequest alloc] init];
  [request setEntity:[objectID entity]];
  
  // Equivalent to
  // predicate = [NSPredicate predicateWithFormat:@"SELF = %@", objectForID];
  NSPredicate *predicate = [NSComparisonPredicate
                            predicateWithLeftExpression:[NSExpression expressionForEvaluatedObject]
                            rightExpression:[NSExpression expressionForConstantValue:objectForID]
                            modifier:NSDirectPredicateModifier
                            type:NSEqualToPredicateOperatorType
                            options:0];
  [request setPredicate:predicate];
  
  NSArray *results = [self executeFetchRequest:request error:nil];
  if ([results count] > 0)
  {
    return [results objectAtIndex:0];
  }
  
  return nil;
}

@end
