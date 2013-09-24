
#import <Foundation/Foundation.h>
#import "DSAlertsSupportCode.h"

@interface DSAppDelegate: UIResponder<UIApplicationDelegate>
+ (id)instance;

/** Device token NSData is passed to completion as the result */
- (void)registerForRemoteNotificationTypes:(UIRemoteNotificationType)types
                                completion:(ds_results_completion)completion NS_AVAILABLE_IOS(3_0);

- (void)clearNotificationCenterForApplication:(UIApplication *)application;

@end
