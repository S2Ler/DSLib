
#import <Foundation/Foundation.h>
#import "DSFieldValidationCriterion.h"

@interface DSFieldValidationCriterion (FactoryMethods)
+ (id)criterionForEmailValidation;
+ (id)criterionForRequiredFieldWithName:(NSString *)fieldName;

/** \param range.location is used as minimum number of chars in field name. If you need min 6 chars max 10 char,
* then range will be [6,4].
*/
+ (id)criterionForCharsRange:(NSRange)range
                   fieldName:(NSString *)fieldName;
@end
