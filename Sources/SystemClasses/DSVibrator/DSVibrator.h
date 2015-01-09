
@import Foundation;

@interface DSVibrator : NSObject

+ (DSVibrator *)sharedInstance;

@property (assign, getter = isEnabled) BOOL enabled;

- (void)vibrate;
@end
