
#import "NSFileManager+Directories.h"


@implementation NSFileManager (NSFileManager_Directories)
+ (NSString *)userDirectoryOfType:(NSSearchPathDirectory)theType {
  NSArray *dirs = 
  NSSearchPathForDirectoriesInDomains(theType, NSUserDomainMask, YES);
  if ([dirs count] > 0) {
    return [dirs objectAtIndex:0];
  } else {
    return nil;
  }
}
@end
