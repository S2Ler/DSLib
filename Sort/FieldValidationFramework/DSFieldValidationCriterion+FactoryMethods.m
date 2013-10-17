
#import "DSFieldValidationCriterion+FactoryMethods.h"
#import "DSFieldValidationCriterionDescription.h"
#import "NSString+Extras.h"

#define DSFieldValidationLocalizedTable @"DSFieldValidation"

@implementation DSFieldValidationCriterion (FactoryMethods)
+ (id)criterionForEmailValidation
{
  NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", EMAIL_REGEX];

  DSFieldValidationCriterionDescription *criterionDescription = [[DSFieldValidationCriterionDescription alloc] init];
  [criterionDescription setTitle:NSLocalizedStringFromTable(@"criterion.email.title", DSFieldValidationLocalizedTable, nil)];
  [criterionDescription setBody:NSLocalizedStringFromTable(@"criterion.email.body", DSFieldValidationLocalizedTable, nil)];
  DSFieldValidationCriterion *criterion = [[DSFieldValidationCriterion alloc] initWithPredicate:predicate
                                                                                    description:criterionDescription];
  return criterion;
}

+ (id)criterionForRequiredFieldWithName:(NSString *)fieldName
{
  NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.length > 0"];
  
  DSFieldValidationCriterionDescription *criterionDescription = [[DSFieldValidationCriterionDescription alloc] init];
  NSString *titleStringFormat
    = NSLocalizedStringFromTable(@"criterion.requiredField.title", DSFieldValidationLocalizedTable, nil);
  [criterionDescription setTitle:[NSString stringWithFormat:titleStringFormat, fieldName]];

  NSString *bodyStringFormat
    = NSLocalizedStringFromTable(@"criterion.requiredField.body", DSFieldValidationLocalizedTable, nil);
  [criterionDescription setBody:[NSString stringWithFormat:bodyStringFormat, fieldName]];
  DSFieldValidationCriterion *criterion = [[DSFieldValidationCriterion alloc] initWithPredicate:predicate
                                                                                    description:criterionDescription];
  return criterion;
}

+ (id)criterionForCharsRange:(NSRange)range
                   fieldName:(NSString *)fieldName
{
  DSFieldValidationCriterionDescription *passwordCriterionDescription
    = [[DSFieldValidationCriterionDescription alloc] init];
  [passwordCriterionDescription setTitle:[NSString stringWithFormat:NSLocalizedString(@"criterion.charsRange.title", nil), fieldName]];
  NSUInteger minChars = range.location;
  NSUInteger maxChars = minChars + range.length;
  [passwordCriterionDescription setBody:[NSString stringWithFormat:NSLocalizedString(@"criterion.charsRange.body", nil), fieldName, minChars, maxChars]];
  NSString *regex = [NSString stringWithFormat:@".{%d,%d}", minChars, maxChars];
  DSFieldValidationCriterion *passwordCriterion
    = [[DSFieldValidationCriterion alloc]
                                   initWithPredicate:[NSString predicateWithRegex:regex]
                                         description:passwordCriterionDescription];
  return passwordCriterion;
}


@end
