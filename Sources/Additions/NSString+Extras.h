
#import <Foundation/Foundation.h>

extern NSString *const EMAIL_REGEX;

@interface NSString(Extras)

- (BOOL) isEmpty;
- (BOOL) hasValue;

+ (BOOL)validateString:(NSString *)theString 
								 regex:(NSString *)theRegex;

+ (BOOL)availableStringPointer:(NSString*)theString;
// return a new autoreleased UUID string
+ (NSString *)generateUuidString;

- (NSString *)stringByLeavingOnlyNumbers;

- (BOOL)containsString:(NSString *)theString;

- (BOOL)beginsWithString:(NSString *)theString;
- (unichar)lastChar;
- (unichar)firstChar;
- (NSString *)stringForPhoneNumber;
- (NSString *)stringWithFirstCharUpperCase;

/** \important!!! theLeftDivider shouldn't be equal to theRightDivider */
- (NSString *)stringBetweenString:(NSString *)theLeftDivider
                        andString:(NSString *)theRightDivider;

//Validation
- (BOOL)validateWithRegex:(NSString *)theRegex;
+ (NSPredicate *)predicateWithRegex:(NSString *)regex;
- (BOOL)validateEmail;
- (NSString *)stringByRemovingNFirstChars:(NSUInteger)theN;
- (NSString *)stringByRemovingPrefix:(NSString *)thePrefixName;

+ (NSString *)stringWithComponents:(NSArray *)components concatenatedBy:(NSString *)separator;

/** Return yes if self string path extension is on of the pathExtensions extensions. */
- (BOOL)isPathExtensionEqualToOneOf:(NSArray *)pathExtensions;

/** \param setter looks like: setParamName */
+ (NSString *)propertyNameFromSetter:(SEL)setter;

- (NSString *)perlSearchRegex;

- (NSString *)truncateToLength:(NSUInteger)lenght;
@end
