//
//  DSFieldValidationCriteria.m
//  DSLib
//
//  Created by Alexander Belyavskiy on 5/29/15.
//  Copyright (c) 2015 DS ltd. All rights reserved.
//

#pragma mark - include
#import "DSFieldValidationCriteria.h"
#import "DSFieldValidationCriterion.h"

@interface DSFieldValidationCriteria ()
@property (nonatomic, strong, nonnull) NSArray *criteria;
@end

@implementation DSFieldValidationCriteria
- (instancetype)initWithCriteria:(NSArray *)criteria
{
  self = [super init];
  if (self) {
    _criteria = criteria;
  }
  return self;
}

+ (instancetype)criteriaWith:(NSArray *)criteria
{
  return [[self alloc] initWithCriteria:criteria];
}

- (NSArray *)validateAgainstObject:(id)object
{
  NSMutableArray *nonPassedCriteria = [NSMutableArray array];
  
  for (DSFieldValidationCriterion *criterion in self.criteria) {
    BOOL isPassesCriterion = [criterion validateWithObject:object];
    if (!isPassesCriterion) {
      [nonPassedCriteria addObject:criterion];
    }
  }
  
  return [nonPassedCriteria copy];

}
@end
