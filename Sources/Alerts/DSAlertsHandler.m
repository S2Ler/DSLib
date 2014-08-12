
#pragma mark - include
#import "DSAlertsHandler.h"
#import "DSMacros.h"
#import "DSAlert.h"
#import "DSQueue.h"
#import "DSAlertView.h"
#import "DSAlertViewFactory.h"
#import "DSAlertButton.h"
#import "Reachability.h"
#import "DSMessage.h"
#import "DSAlertsQueue.h"
#import "DSAlertQueue+Private.h"

#pragma mark - private
@interface DSAlertsHandler ()
@property (nonatomic, strong) DSQueue *alertsQueue;
@property (nonatomic, strong) id<DSAlertView> currentAlertView;
@property (nonatomic, strong) DSAlert *currentAlert;
@property (nonatomic, assign) BOOL isOnline;
@property (nonatomic, assign) BOOL shouldShowNotReachableAlerts;
@end

@implementation DSAlertsHandler

- (void)dealloc
{
  [[NSNotificationCenter defaultCenter] removeObserver:self];
}

+ (id)sharedInstance
{
  DEFINE_SHARED_INSTANCE_USING_BLOCK(^
  {
    return [[DSAlertsHandler alloc] init];
  });
}

- (id)init
{
  self = [super init];
  if (self != nil) {
    _alertsQueue = [DSQueue queue];
    _shouldShowNotReachableAlerts = YES;
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(applicationDidResignActive:)
                                                 name:UIApplicationWillResignActiveNotification
                                               object:nil];
  }
  return self;
}

- (void)setIsOnline:(BOOL)isOnline
{
  _isOnline = isOnline;
  if (isOnline) {
    [self setShouldShowNotReachableAlerts:YES];
  }
}

- (void)setReachability:(Reachability *)reachability
{
  if ([self reachability]) {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
  }

  _reachability = reachability;
  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(reachabilityChanged:)
                                               name:kReachabilityChangedNotification
                                             object:reachability];
}

- (void)reachabilityChanged:(NSNotification *)notification
{
  if ([(Reachability *)[notification object] isReachable])  {
    [self setIsOnline:YES];
  }
}


#pragma mark - public
- (void)showAlert:(DSAlert *)theAlert modally:(BOOL)isModalAlert
{
  NSAssert(isModalAlert == YES, @"Only modal alert is supported now");

  [self queueAlert:theAlert];
}

- (DSAlertsQueue *)detachAlertsQueue
{
  DSAlertsQueue *queue = [[DSAlertsQueue alloc] init];
  [queue setAlertsHandler:self];
  return queue;
}

#pragma mark - alert
- (void)showModalAlert:(DSAlert *)theAlert
{
  id<DSAlertView> alertView = [DSAlertViewFactory modalAlertViewWithAlert:theAlert
                                                                 delegate:self];

  [self setCurrentAlertView:alertView];
  [self setCurrentAlert:theAlert];

  [alertView show];
}

#pragma mark - queue
- (BOOL)isAlertInQueue:(DSAlert *)theAlert
{
  BOOL currentAlertEquals = [[self currentAlert] isAlertMessageEqualWith:theAlert];
  if (currentAlertEquals == YES) {
    return YES;
  }

  BOOL alertInQueue = NO;
  for (DSAlert *queueAlert in [self alertsQueue]) {
    if ([queueAlert isAlertMessageEqualWith:theAlert] == YES) {
      alertInQueue = YES;
      break;
    }
  }

  return alertInQueue;
}

- (BOOL)isMessage:(DSMessage *)message inCollection:(id<NSFastEnumeration>)collection {
  BOOL alertInCollection = NO;
  for (DSMessage *collectionMessage in collection) {
    if ([collectionMessage isEqualToMessage:message] == YES) {
      alertInCollection = YES;
      break;
    }
  }
  
  return alertInCollection;
}

- (void)queueAlert:(DSAlert *)theAlert
{
  if (!theAlert) {
    return;
  }

  //If the same message is already in queue don't do anything
  if ([self isAlertInQueue:theAlert] == YES) {
    return;
  }

  if ([self isMessage:[theAlert message]
         inCollection:[self filterOutMessages]]) {
    return;
  }
  else if ([[[theAlert message] domain] isEqualToString:NSURLErrorDomain] &&
    [[[theAlert message] code] integerValue] == NSURLErrorNotConnectedToInternet) {

    if ([self shouldShowNotReachableAlerts]) {
      [[self alertsQueue] push:theAlert];
    }

    [self setIsOnline:NO];
#if DSAlertsHandler_SHOW_NO_INTERNET_CONNECTION_POPUPS_ONCE
    [self setShouldShowNotReachableAlerts:NO];
#endif
  }
  else {
    [[self alertsQueue] push:theAlert];
  }

  [self processNextAlertFromQueue];
}

- (void)processNextAlertFromQueue
{
  if ([self currentAlertView] == nil) {
    DSAlert *nextAlert = [[self alertsQueue] pop];
    if (nextAlert != nil) {
      [self showModalAlert:nextAlert];//NOTE: when will add notifications(modeless alerts), fix this call
    }
  }
}

- (void)alertDismissed
{
  //Cleanup
  [self setCurrentAlertView:nil];
  [self setCurrentAlert:nil];

  [self processNextAlertFromQueue];
}

#pragma mark - UIAlertViewDelegate
- (void)alertViewCancel:(id<DSAlertView>)alertView
{
  [self alertDismissed];
}

- (void)        alertView:(id<DSAlertView>)theAlertView
didDismissWithButtonIndex:(NSInteger)theButtonIndex
{
  DSAlertButton *clickedButton = nil;

  if ([theAlertView isCancelButtonAtIndex:theButtonIndex]) {
    clickedButton = [[self currentAlert] cancelButton];
  }
  else {
    clickedButton = [[[self currentAlert] otherButtons]
                     objectAtIndex:(NSUInteger)(theButtonIndex - ([[self currentAlert] cancelButton] ? 1: 0))];
  }

  [clickedButton invoke];
  [self alertDismissed];
}

#pragma mark - Notifications
- (void)applicationDidResignActive:(NSNotification *)notification
{
  [[self alertsQueue] removeAll];
  [[self currentAlertView] dismissAnimated:NO];
}

@end
