
#import "DSAppDelegate.h"
#import "DSMessage.h"

#pragma mark - private
@interface DSAppDelegate()
@property (nonatomic, strong) ds_results_completion registerForRemoteNotificationsCompletion;
@end

@implementation DSAppDelegate
+ (instancetype)instance
{
  return [[UIApplication sharedApplication] delegate];
}

- (void)registerForRemoteNotificationTypes:(UIRemoteNotificationType)types completion:(ds_results_completion)completion
{
  [self setRegisterForRemoteNotificationsCompletion:completion];
  [[UIApplication sharedApplication] registerForRemoteNotificationTypes:types];

  [self performSelector:@selector(registrationFailedDueToTimeout)
             withObject:nil
             afterDelay:30.0];
}

- (void)registrationFailedDueToTimeout
{
  if ([self registerForRemoteNotificationsCompletion]) {
    [self registerForRemoteNotificationsCompletion](FAILED_WITH_MESSAGE, nil, NO_RESULTS);
    [self setRegisterForRemoteNotificationsCompletion:nil];
  }
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
  [[self class] cancelPreviousPerformRequestsWithTarget:self];
  
  if ([self registerForRemoteNotificationsCompletion]) {
    [self registerForRemoteNotificationsCompletion](SUCCEED_WITH_MESSAGE, NO_MESSAGE, deviceToken);
    [self setRegisterForRemoteNotificationsCompletion:nil];
  }
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
  [[self class] cancelPreviousPerformRequestsWithTarget:self];  
  
  DSMessage *errorMessage = [DSMessage messageWithError:error];
  if ([self registerForRemoteNotificationsCompletion]) {
    [self registerForRemoteNotificationsCompletion](FAILED_WITH_MESSAGE, errorMessage, NO_RESULTS);
    [self setRegisterForRemoteNotificationsCompletion:nil];
  }
}

- (void)clearNotificationCenterForApplication:(UIApplication *)application
{
  [application setApplicationIconBadgeNumber:0];
}

@end
