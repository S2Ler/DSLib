
#pragma mark - include
#import "DSFieldValidationCriterion.h"
#import "DSFieldValidationCriterionDescription.h"
#import "NSString+Encoding.h"

#pragma mark - private
@interface DSFieldValidationCriterion()
@end

@implementation DSFieldValidationCriterion

- (id)initWithPredicate:(NSPredicate *)predicate description:(DSFieldValidationCriterionDescription *)description
{
  self = [super init];
  if (self) {
    _predicate = predicate;
    _criterionDescription = description;
    _trimWhiteSpaces = YES;
  }
  return self;
}

- (id)initWithValidationBlock:(DSFieldValidationCriterionBlock)validationBlock
                  description:(DSFieldValidationCriterionDescription *)description
{
  self = [super init];
  if (self) {
    _validationBlock = validationBlock;
    _criterionDescription = description;
    _trimWhiteSpaces = YES;
  }
  return self;
}


- (BOOL)validateWithObject:(id)object
{

  if ([object isKindOfClass:[NSString class]]) {
    if ([self trimWhiteSpaces]) {
      object = [(NSString *)object trimWhiteSpaces];
    }
  }
  if (object == nil) {
    object = @"";
  }

  if ([self predicate]) {
    return [[self predicate] evaluateWithObject:object];
  }
  else {
    return [self validationBlock](object);
  }
}

@end
