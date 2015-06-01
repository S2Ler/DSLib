//
//  DSFieldValidationCriteria.h
//  DSLib
//
//  Created by Alexander Belyavskiy on 5/29/15.
//  Copyright (c) 2015 DS ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface DSFieldValidationCriteria : NSObject
+ (instancetype)criteriaWith:(NSArray *)criteria;
- (instancetype)initWithCriteria:(NSArray *)criteria;
- (instancetype)newMergedCopyWith:(DSFieldValidationCriteria *)otherCriteria;

/** @return empty array if all criterias has been passed. Otherwise array of failed criteria */
- (nonnull NSArray *)validateAgainstObject:(nullable id)object;
@end

NS_ASSUME_NONNULL_END
