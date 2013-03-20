
#import "UIDevice+Additions.h"


@implementation UIDevice (Additions)
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

- (NSString *)appUUID
{
  NSString *appName = [[[NSBundle mainBundle] infoDictionary] objectForKey:(NSString *)kCFBundleNameKey];
  NSString *deviceIDKey = [appName stringByAppendingString:@"_deviceUuid"];

  NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
  if ([userDefaults objectForKey:deviceIDKey]) {
    return [userDefaults objectForKey:deviceIDKey];
  }

  // Get the users Device Unique ID
  CFUUIDRef uuidRef = CFUUIDCreate(NULL);
  CFStringRef cfUuid = CFUUIDCreateString(NULL, uuidRef);
  CFRelease((CFTypeRef)uuidRef);
  NSString *deviceUuid = (__bridge_transfer NSString *)cfUuid;

  [userDefaults setObject:deviceUuid forKey:deviceIDKey];
  [userDefaults synchronize];

  return deviceUuid;
}

#include <mach/mach_host.h>
#include <mach/host_info.h>
+ (unsigned int)countProcessors
{
	host_basic_info_data_t hostInfo;
	mach_msg_type_number_t infoCount;
	
	infoCount = HOST_BASIC_INFO_COUNT;
	host_info(mach_host_self(), HOST_BASIC_INFO,
            (host_info_t)&hostInfo, &infoCount);
	
	return (unsigned int)(hostInfo.max_cpus);
}

@end
