
#import <Foundation/Foundation.h>

//TODO: doesn't work with cross references.
//23.11.2012 Tried to add support for cross references but got an issues with description for NSNumber, NSString etc.
#define OVERWRITE_DESCRIPTION 0

@interface NSObject (DSAdditions)
#if !OVERWRITE_DESCRIPTION
- (NSString *)longDescription;
#endif

+ (NSArray *)propertyNames;
@end
