#import "DSCFunctions.h"


#if TARGET_OS_IPHONE
BOOL isIPadIdiom(void)
{
  return [[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad;
}

#endif

NSString *DSApplicationDocumentDirectoryPath(void)
{
  NSArray *documentsDirectories
      = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
          NSUserDomainMask,
          YES);

  assert([documentsDirectories count] > 0);

  if ([documentsDirectories count] > 0) {
    return [documentsDirectories objectAtIndex:0];
  }
  else {
    return nil;
  }
}

NSURL *DSApplicationDocumentDirectoryURL(void)
{

  NSString *path = DSApplicationDocumentDirectoryPath();

  assert(path);

  return [NSURL fileURLWithPath:path];
}

NSUInteger DSNumberOfParamsInSelector(SEL theSelector)
{
  NSString *selector = NSStringFromSelector(theSelector);
  NSArray *selectorComponents = [selector componentsSeparatedByString:@":"];
  assert([selectorComponents count] > 0);

  return [selectorComponents count] - 1;
}

DSFileSize getFreeDiskSpace(NSError **errorRef)
{
  DSFileSize totalSpace;
  DSFileSize totalFreeSpace = DSFileSizeUndefined;
  NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
  NSDictionary *dictionary = [[NSFileManager defaultManager] attributesOfFileSystemForPath:[paths lastObject]
                                                                                     error:errorRef];

  if (dictionary) {
    NSNumber *fileSystemSizeInBytes = [dictionary objectForKey:NSFileSystemSize];
    NSNumber *freeFileSystemSizeInBytes = [dictionary objectForKey:NSFileSystemFreeSize];
    totalSpace = [fileSystemSizeInBytes longLongValue];
    totalFreeSpace = [freeFileSystemSizeInBytes longLongValue];
    NSLog(@"Memory Capacity of %llu MiB with %llu MiB Free memory available.", ((totalSpace / 1024ll) / 1024ll), ((totalFreeSpace / 1024ll) / 1024ll));
  }
  else {
    NSLog(@"Error Obtaining System Memory Info: Domain = %@, Code = %ld", [*errorRef domain], (long) [*errorRef code]);
  }

  return totalFreeSpace;
}

#import <mach/mach.h>

struct task_basic_info get_task_info(char **errorStringRef)
{
  struct task_basic_info info;
  mach_msg_type_number_t size = sizeof(info);
  kern_return_t kerr = task_info(mach_task_self(),
      TASK_BASIC_INFO,
      (task_info_t) &info,
      &size);
  if (kerr == KERN_SUCCESS ) {
    return info;
  }
  else {
    char *errorString = mach_error_string(kerr);
    NSLog(@"Error: %s", errorString);
    *errorStringRef = errorString;
    return info;
  }
}

float randomFloatInRange(float smallNumber, float bigNumber)
{
  float diff = bigNumber - smallNumber;
  return (((float) (arc4random() % ((unsigned) RAND_MAX + 1)) / RAND_MAX) * diff) + smallNumber;
}
