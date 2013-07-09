//
//  OCFunctions.h
//
//  Created by Alexander Belyavskiy on 4/27/12.
//

#import <Foundation/Foundation.h>

#pragma mark - macros
#define ASSERT_ABSTRACT_METHOD NSAssert(@"%@ is abstract in class '%@'. Overwrite in subclasses", NSStringFromSelector(_cmd), NSStringFromClass([self class]))
#define UNHANDLED_IF else{NSAssert(NO,@"Check last else statement in class: %@; method: %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd));}

#if TARGET_OS_IPHONE
BOOL isIPadIdiom(void);
#endif

#pragma mark - paths
NSString *DSApplicationDocumentDirectoryPath(void);
NSURL *DSApplicationDocumentDirectoryURL(void);

NSUInteger DSNumberOfParamsInSelector(SEL theSelector);
