#import <Foundation/Foundation.h>

/** Query various device params */
@interface UIDevice (Addittions)

/** \return the system version of the current device */
+ (NSString *)deviceIOSVersion;

/** Query whether current device system version is greate or equal 
 then theIOSVersionToCompare */
+ (BOOL)isIOSVersionGreaterOrEqualTo:(NSString *)theIOSVersionToCompare;
@end
