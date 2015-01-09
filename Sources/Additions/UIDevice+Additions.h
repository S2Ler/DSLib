@import Foundation;
@import UIKit;

/** Query various device params */
@interface UIDevice (Additions)

/** \return the system version of the current device */
+ (NSString *)deviceIOSVersion;

/** Query whether current device system version is greate or equal 
 then theIOSVersionToCompare */
+ (BOOL)isIOSVersionGreaterOrEqualTo:(NSString *)theIOSVersionToCompare;

- (NSString *)appUUID;

+ (unsigned int)countProcessors;

- (NSString *)machineCode;
@end
