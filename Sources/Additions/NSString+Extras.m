#import "NSString+Extras.h"

NSString *const EMAIL_REGEX = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";

@implementation NSString(Extras)

- (BOOL) isEmpty
{
	return ([[self stringByTrimmingCharactersInSet:
						[NSCharacterSet whitespaceAndNewlineCharacterSet]]length] == 0);
}

- (BOOL)hasValue
{
  return ![self isEmpty];
}

+ (BOOL)validateString:(NSString *)theString 
								 regex:(NSString *)theRegex
{
	NSPredicate *predicate =
	[NSPredicate predicateWithFormat:@"SELF MATCHES %@", theRegex];
	return [predicate evaluateWithObject:theString];
}

+ (BOOL)availableStringPointer:(NSString*)theString
{
	if(theString == nil || theString == NULL)
		return NO;
	return YES;
}

+ (NSString *)generateUuidString
{
  CFUUIDRef uuid = CFUUIDCreate(kCFAllocatorDefault);
  
  NSString *uuidString
    = (NSString *)CFBridgingRelease(CFUUIDCreateString(kCFAllocatorDefault, uuid));
  CFRelease(uuid);
  
  return uuidString;
}

- (NSString *)stringByLeavingOnlyNumbers
{
  unichar *chars = malloc(sizeof(unichar)*[self length]);
  NSUInteger charsIdx = 0;
  
  for (NSUInteger idx = 0; idx < [self length]; idx++) {
    unichar c = [self characterAtIndex:idx];
    if (c == '1' ||
        c == '2' ||
        c == '3' ||
        c == '4' ||
        c == '5' ||
        c == '6' ||
        c == '7' ||
        c == '8' ||
        c == '9' ||
        c == '0') 
    {
      chars[charsIdx++] = c;      
    }
  }
  
  NSString *fixedString = [NSString stringWithCharacters:chars
                                                  length:charsIdx];
  free(chars);
  return fixedString;
}

- (BOOL)containsString:(NSString *)theString
{
  if (theString == nil) return NO;
  
  BOOL constrains = [self rangeOfString:theString].location != NSNotFound;
  return constrains;
}

- (BOOL)validateWithRegex:(NSString *)theRegex
{
  
	return [[NSString predicateWithRegex:theRegex] evaluateWithObject:self];
}

+ (NSPredicate *)predicateWithRegex:(NSString *)regex
{
	NSPredicate *predicate =
	[NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
  return predicate;
}

- (BOOL)validateEmail
{
  NSString *emailRegex = EMAIL_REGEX;
  
  BOOL validated = [self validateWithRegex:emailRegex];
  
  return validated;
}

- (NSString *)stringByRemovingNFirstChars:(NSUInteger)theN
{
  NSUInteger stringLength = [self length];
  if (stringLength <= theN) {
    return @"";
  }
  else if (theN == 0) {
    return [self copy];
  }
  
  NSRange rangeToRemove = NSMakeRange(0, theN);
  return [self stringByReplacingCharactersInRange:rangeToRemove
                                       withString:@""];
}

- (NSString *)stringByRemovingPrefix:(NSString *)thePrefixName
{
  return [self stringByRemovingNFirstChars:[thePrefixName length]];
}

+ (NSString *)stringWithComponents:(NSArray *)components concatenatedBy:(NSString *)separator
{
  return [components componentsJoinedByString:separator];
}

- (BOOL)isPathExtensionEqualToOneOf:(NSArray *)pathExtensions
{
  NSString *selfExtension = [self pathExtension];
  for (NSString *extension in pathExtensions) {
    if ([[extension lowercaseString] isEqualToString:[selfExtension lowercaseString]]) {
      return YES;
    }
  }

  return NO;
}

+ (NSString *)propertyNameFromSetter:(SEL)setter
{
  NSMutableString *propertyName = [[NSStringFromSelector(setter) stringByRemovingPrefix:@"set"] mutableCopy];
  [propertyName replaceCharactersInRange:NSMakeRange(0, 1)
                              withString:[[propertyName substringToIndex:1] lowercaseString]];
  [propertyName deleteCharactersInRange:NSMakeRange([propertyName length] - 1, 1)];
  return propertyName;
}


- (BOOL)beginsWithString:(NSString *)theString
{
  if (theString == nil) {
    return NO;
  }
  
  if ([theString isEqualToString:@""]) {
    return YES;
  }
  
  return [self hasPrefix:theString];
}


- (NSString *)stringBetweenString:(NSString *)theLeftDivider
                        andString:(NSString *)theRightDivider
{
  NSRange leftDividerRange;
  NSRange rightDividerRange;
  
  if (theLeftDivider == nil || [theLeftDivider isEmpty] == YES) {
    leftDividerRange.location = 0;
    leftDividerRange.length = 0;
  }
  else  {
    leftDividerRange = [self rangeOfString:theLeftDivider];
    if (leftDividerRange.location == NSNotFound) {
      return nil;
    }
  }
  
  if (theRightDivider == nil || [theRightDivider isEmpty] == YES) {
    rightDividerRange.location = [self length];
    rightDividerRange.length = 0;
  }
  else {
    rightDividerRange = [self rangeOfString:theRightDivider];
    if (rightDividerRange.location == NSNotFound) {
      return nil;
    }
  }
  
  NSUInteger leftDivider = NSMaxRange(leftDividerRange);
  NSUInteger rightDivider = rightDividerRange.location;
  
  if (rightDivider < leftDivider) return nil;
  
  NSRange returnStringRange = NSMakeRange(leftDivider,
                                          rightDivider - leftDivider);
  
  NSString *returnString = [self substringWithRange:returnStringRange];
  return returnString;
}

- (unichar)lastChar
{
  if ([self isEmpty] == NO) {
    return [self characterAtIndex:[self length] - 1];
  }
  else {
    return 0;
  }
}

- (unichar)firstChar
{
  if ([self isEmpty] == NO) {
    return [self characterAtIndex:0];
  }
  else {
    return 0;
  }
}

- (NSString *)stringForPhoneNumber
{
  unichar *chars = malloc(sizeof(unichar)*[self length]);
  NSUInteger charsIdx = 0;
  
  for (NSUInteger idx = 0; idx < [self length]; idx++) {
    unichar c = [self characterAtIndex:idx];
    if (c == '1' ||
        c == '2' ||
        c == '3' ||
        c == '4' ||
        c == '5' ||
        c == '6' ||
        c == '7' ||
        c == '8' ||
        c == '9' ||
        c == '0' ||
        c == '+' ||
        c == ')' ||
        c == '(')
    {
      chars[charsIdx++] = c;
    }
  }
  
  NSString *fixedString = [NSString stringWithCharacters:chars
                                                  length:charsIdx];
  free(chars);
  return fixedString;
}

@end
