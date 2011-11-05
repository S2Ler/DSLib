
#import <Foundation/Foundation.h>

@interface NSString(Extras)

- (BOOL) isEmpty;

+ (BOOL)validateString:(NSString *)theString 
								 regex:(NSString *)theRegex;

+ (BOOL)availableStringPointer:(NSString*)theString;
// return a new autoreleased UUID string
+ (NSString *)generateUuidString;

- (NSString *)stringByLeavingOnlyNumbers;


@end
