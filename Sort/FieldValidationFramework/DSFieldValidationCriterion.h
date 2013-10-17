
#import <Foundation/Foundation.h>

@class DSFieldValidationCriterionDescription;

/** Returns whether object passed validation */
typedef BOOL (^DSFieldValidationCriterionBlock)(id object);

@interface DSFieldValidationCriterion: NSObject
@property (nonatomic, strong) NSPredicate *predicate;
@property (nonatomic, strong) DSFieldValidationCriterionDescription *criterionDescription;
/** Default is YES */
@property (nonatomic, assign) BOOL trimWhiteSpaces;
@property (nonatomic, copy) DSFieldValidationCriterionBlock validationBlock;

- (id)initWithPredicate:(NSPredicate *)predicate
            description:(DSFieldValidationCriterionDescription *)description;
- (id)initWithValidationBlock:(DSFieldValidationCriterionBlock)validationBlock
                  description:(DSFieldValidationCriterionDescription *)description;

- (BOOL)validateWithObject:(id)object;
@end
