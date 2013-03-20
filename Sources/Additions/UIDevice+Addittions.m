
#import "UIDevice+Addittions.h"


@implementation UIDevice (Addittions)
+ (NSString *)deviceIOSVersion {
  static NSString *iosVersion = nil;
  
  if (!iosVersion) {
    iosVersion = [[UIDevice currentDevice] systemVersion];
  }
  
  return iosVersion;
}

+ (BOOL)isIOSVersionGreaterOrEqualTo:(NSString *)theIOSVersionToCompare {
  return ([[self deviceIOSVersion]
           compare:theIOSVersionToCompare
           options:NSNumericSearch] != NSOrderedAscending);
}

@end
