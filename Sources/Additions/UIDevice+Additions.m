
#import "UIDevice+Additions.h"
#import <sys/sysctl.h>
#include <mach/mach_host.h>
#include <mach/host_info.h>

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


+ (unsigned int)countProcessors
{
	host_basic_info_data_t hostInfo;
	mach_msg_type_number_t infoCount;
	
	infoCount = HOST_BASIC_INFO_COUNT;
	host_info(mach_host_self(), HOST_BASIC_INFO,
            (host_info_t)&hostInfo, &infoCount);
	
	return (unsigned int)(hostInfo.max_cpus);
}

- (NSString *)machineCode
{
  //	NSDictionary*models = [NSDictionary
  //						   dictionaryWithObjects:[NSArray arrayWithObjects:@"iPhone", @"iPhone 3G", @"iPhone 3GS", @"iPhone 4", nil]
  //						   forKeys:[NSArray arrayWithObjects:@"iPhone1,1", @"iPhone1,2", @"iPhone2,1", @"iPhone3,1", nil]
  //						   ];
	size_t size;
	
	// Set 'oldp' parameter to NULL to get the size of the data
	// returned so we can allocate appropriate amount of space
	sysctlbyname("hw.machine", NULL, &size, NULL, 0);
	
	// Allocate the space to store name
	char *name = malloc(size);
	
	// Get the platform name
	sysctlbyname("hw.machine", name, &size, NULL, 0);
	
	// Place name into a string
	NSString *machine = [NSString stringWithFormat:@"%s",name];
	
	
	// Done with this
	free(name);
	
	return machine;
}

@end
