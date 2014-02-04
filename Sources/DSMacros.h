#import <Foundation/Foundation.h>

#define DS_SAVE_RELEASE(obj) [obj release]; obj = nil;

#define DEFINE_SHARED_INSTANCE_USING_BLOCK(block) \
static dispatch_once_t pred = 0; \
__strong static id _sharedObject = nil; \
dispatch_once(&pred, ^{ \
_sharedObject = block(); \
}); \
return _sharedObject;

#define iOS7 ([[[UIDevice currentDevice] systemVersion] doubleValue] >= 7)

#define ASSERT_MAIN_THREAD NSAssert([[NSThread currentThread] isEqual:[NSThread mainThread]], @"%@:%@ should run main thread.", NSStringFromClass([self class]), NSStringFromSelector(_cmd))

#define CASSERT_MAIN_THREAD NSCAssert([[NSThread currentThread] isEqual:[NSThread mainThread]], @"This block should run main thread.")

#define DS_DESIGNATED_INIT
