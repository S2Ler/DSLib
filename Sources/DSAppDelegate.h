
@import Foundation;
#import "DSAlertsSupportCode.h"

@interface DSAppDelegate: UIResponder<UIApplicationDelegate>
+ (instancetype)instance;

/** Device token NSData is passed to completion as the result */
- (void)registerForRemoteNotificationTypes:(UIRemoteNotificationType)types
                                completion:(ds_results_completion)completion NS_AVAILABLE_IOS(3_0);

- (void)clearNotificationCenterForApplication:(UIApplication *)application;

@end
