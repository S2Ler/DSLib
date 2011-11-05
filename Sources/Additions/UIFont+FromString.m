
#import "UIFont+FromString.h"


@implementation UIFont(FromString)
+ (UIFont *)fontFromString:(NSString *)aFontStringDefinintion 
{
	NSArray *fontCompanents = [aFontStringDefinintion componentsSeparatedByString:@" "];
  
	UIFont *fontFromString = 
	[UIFont fontWithName:[fontCompanents objectAtIndex:0]
                  size:[[fontCompanents objectAtIndex:1] floatValue]];
  
	return fontFromString;
}
@end
