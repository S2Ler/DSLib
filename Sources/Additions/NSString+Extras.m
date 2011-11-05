#import "NSString+Extras.h"

@implementation NSString(Extras)

- (BOOL) isEmpty
{
	return ([[self stringByTrimmingCharactersInSet:
						[NSCharacterSet whitespaceAndNewlineCharacterSet]]length] == 0);
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
    = (NSString *)CFUUIDCreateString(kCFAllocatorDefault, uuid);
  [uuidString autorelease];
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
@end
