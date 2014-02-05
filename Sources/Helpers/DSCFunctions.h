
#import <Foundation/Foundation.h>

#pragma mark - macros




#if TARGET_OS_IPHONE
BOOL isIPadIdiom(void);
#endif


#pragma mark - paths
NSString *DSApplicationDocumentDirectoryPath(void);
NSURL *DSApplicationDocumentDirectoryURL(void);

NSUInteger DSNumberOfParamsInSelector(SEL theSelector);
