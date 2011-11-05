
#import <Foundation/Foundation.h>

@interface DSVibrator : NSObject

+ (DSVibrator *)sharedInstance;

@property (assign, getter = isEnabled) BOOL enabled;

- (void)vibrate;
@end
