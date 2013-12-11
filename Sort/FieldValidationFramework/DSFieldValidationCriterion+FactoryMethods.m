
#import "DSFieldValidationCriterion+FactoryMethods.h"
#import "DSFieldValidationCriterionDescription.h"
#import "NSString+Extras.h"
#import "NSBundle+DSBundle.h"

#define DSFieldValidationLocalizedTable @"DSFieldValidation"

@implementation DSFieldValidationCriterion (FactoryMethods)
+ (id)criterionForEmailValidation
{
  NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", EMAIL_REGEX];

  DSFieldValidationCriterionDescription *criterionDescription = [[DSFieldValidationCriterionDescription alloc] init];
  [criterionDescription setTitle:NSLocalizedStringFromTableInBundle(@"criterion.email.title", DSFieldValidationLocalizedTable, [NSBundle DSLibBundle], nil)];
  [criterionDescription setBody:NSLocalizedStringFromTableInBundle(@"criterion.email.body", DSFieldValidationLocalizedTable, [NSBundle DSLibBundle], nil)];
  DSFieldValidationCriterion *criterion = [[DSFieldValidationCriterion alloc] initWithPredicate:predicate
                                                                                    description:criterionDescription];
  return criterion;
}

+ (id)criterionForRequiredFieldWithName:(NSString *)fieldName
{
  NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.length > 0"];
  
  DSFieldValidationCriterionDescription *criterionDescription = [[DSFieldValidationCriterionDescription alloc] init];
  NSString *titleStringFormat
    = NSLocalizedStringFromTableInBundle(@"criterion.requiredField.title", DSFieldValidationLocalizedTable, [NSBundle DSLibBundle], nil);
  [criterionDescription setTitle:[NSString stringWithFormat:titleStringFormat, fieldName]];

  NSString *bodyStringFormat
    = NSLocalizedStringFromTableInBundle(@"criterion.requiredField.body", DSFieldValidationLocalizedTable, [NSBundle DSLibBundle], nil);
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
  [passwordCriterionDescription setTitle:[NSString stringWithFormat:NSLocalizedStringFromTableInBundle(@"criterion.charsRange.title", DSFieldValidationLocalizedTable, [NSBundle DSLibBundle], nil), fieldName]];
  NSUInteger minChars = range.location;
  NSUInteger maxChars = minChars + range.length;
  [passwordCriterionDescription setBody:[NSString stringWithFormat:NSLocalizedStringFromTableInBundle(@"criterion.charsRange.body", DSFieldValidationLocalizedTable, [NSBundle DSLibBundle], nil), fieldName, minChars, maxChars]];
  NSString *regex = [NSString stringWithFormat:@".{%d,%d}", minChars, maxChars];
  DSFieldValidationCriterion *passwordCriterion
    = [[DSFieldValidationCriterion alloc]
                                   initWithPredicate:[NSString predicateWithRegex:regex]
                                         description:passwordCriterionDescription];
  return passwordCriterion;
}


@end
