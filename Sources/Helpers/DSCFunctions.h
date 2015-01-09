
@import Foundation;
#import "DSConstants.h"
#pragma mark - macros




#if TARGET_OS_IPHONE
BOOL isIPadIdiom(void);
#endif


#pragma mark - paths
NSString *DSApplicationDocumentDirectoryPath(void);
NSURL *DSApplicationDocumentDirectoryURL(void);

NSUInteger DSNumberOfParamsInSelector(SEL theSelector);

DSFileSize getFreeDiskSpace(NSError **errorRef);
struct task_basic_info get_task_info(char **errorStringRef);

float randomFloatInRange(float smallNumber, float bigNumber);

