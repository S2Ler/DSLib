
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

