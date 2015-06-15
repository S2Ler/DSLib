#import <libkern/OSAtomic.h>
#import "DSPassCodeController.h"
#import "DSPassCodeControllerDelegate.h"
#import "NSString+Extras.h"
#import "DSConstants.h"
#import "DSMessage.h"
@import UIKit;
@import LocalAuthentication;

@interface DSPassCodeController ()
{
  NSString *_PASSCODE_IDENTIFIER;
  NSString *_TOUCH_ID_ENABLED_IDENTIFIER;
  int64_t _timerTicks;
  LAPolicy _policy;
}

@property (nonatomic, strong) NSString *serviceName;
@property (assign) BOOL isUnlocked;

@end

@implementation DSPassCodeController

- (void)dealloc
{
  [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)setLockTimeInterval:(NSTimeInterval)lockTimeInterval
{
  _lockTimeInterval = lockTimeInterval;
  
  //iOS 8 work around
  NSNumber *number = @(lockTimeInterval);
  NSData *data = [NSKeyedArchiver archivedDataWithRootObject:number];
  [[NSUserDefaults standardUserDefaults] setObject:data forKey:@"DSPassCodeController_lockTimeInterval"];
  [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)loadSavedTimeInterval
{
  NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:@"DSPassCodeController_lockTimeInterval"];
  if (data) {
    NSNumber *number = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    _lockTimeInterval = [number doubleValue];
  }
}

- (NSString *)PASSCODE_IDENTIFIER
{
  if (!_PASSCODE_IDENTIFIER) {
    _PASSCODE_IDENTIFIER = [NSString stringWithFormat:@"passcode_id:%@", [self uniqueID]];
  }
  return _PASSCODE_IDENTIFIER;
}

- (NSString *)TOUCH_ID_ENABLED_IDENTIFIER
{
  if (!_TOUCH_ID_ENABLED_IDENTIFIER) {
    _TOUCH_ID_ENABLED_IDENTIFIER = [NSString stringWithFormat:@"touch_id_enabled:%@", self.uniqueID];
  }

  return _TOUCH_ID_ENABLED_IDENTIFIER;
}

- (void)setUniqueID:(NSString *)uniqueID
{
  _PASSCODE_IDENTIFIER = nil;
  _uniqueID = uniqueID;
}

- (id)initWithUniqueID:(NSString *)uniqueID serviceName:(NSString *)serviceName
{
  self = [super init];
  if (self) {
    _policy = LAPolicyDeviceOwnerAuthenticationWithBiometrics;
    [self setUniqueID:uniqueID];
    _serviceName = serviceName;

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(applicationDidBecomeActive:)
                                                 name:UIApplicationWillEnterForegroundNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(applicationWillResignActive:)
                                                 name:UIApplicationDidEnterBackgroundNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(applicationWillTerminateNotification:)
                                                 name:UIApplicationWillTerminateNotification
                                               object:nil];
    _isUnlocked = YES;
    [self lockIfNeeded];
    [self loadSavedTimeInterval];
  }

  return self;
}

- (id)init
{
  NSAssert(FALSE, @"Please use initWithUniqueID:serviceName: selector");
  return [self initWithUniqueID:nil serviceName:@"DEFAULT_SERVICE_NAME"];
}

- (void)setResignActiveDate:(NSDate *)resignActiveDate
{
  [self setKeychainValue:resignActiveDate forIdentifier:@"DSPassCodeController_resignTime"];
}

- (NSDate *)resignActiveDate
{
  NSDate *resignActiveDate = (NSDate *)[self searchKeychainValueCopyMatching:@"DSPassCodeController_resignTime"];
  return resignActiveDate;
}

- (void)applicationWillResignActive:(NSNotification *)notification
{
  [self setResignActiveDate:[NSDate date]];
}

- (void)applicationDidBecomeActive:(NSNotification *)notification
{
  [self lockIfNeeded];
}

- (void)applicationWillTerminateNotification:(NSNotification *)notification
{
  [self setResignActiveDate:nil];
}

- (void)lockIfNeeded
{
  NSDate *resignActiveDate = [self resignActiveDate];
  NSTimeInterval applicationWasInactiveForTimeInterval = [[NSDate date] timeIntervalSinceDate:resignActiveDate];
  if ([self isPassCodeEntered]
      && (![self unlocked] ||
          !resignActiveDate ||
          (applicationWasInactiveForTimeInterval > 0 &&
              applicationWasInactiveForTimeInterval > [self lockTimeInterval]))) {
    [self lock];
    [[self delegate] passCodeController:self didRequestToLockScreenWithUnlockBlock:^BOOL(NSString *unlockCode)
    {
      if ([self isPasswordMatchWithStored:unlockCode]) {
        [self unlock];
        return YES;
      }
      else {
        [self lock];
        return NO;
      }
    }];
  }
}

- (void)storePassword:(NSString *)aPass
{
  if (aPass && ![aPass isEmpty]) {
    [self setKeychainValue:aPass forIdentifier:[self PASSCODE_IDENTIFIER]];
  }
  else {
    [self deleteKeychainValue:[self PASSCODE_IDENTIFIER]];
  }

  [self setIsUnlocked:YES];
}

- (BOOL)isPasswordMatchWithStored:(NSString *)aMatchPassword
{
  NSString *storedPassCode = (NSString *)[self searchKeychainValueCopyMatching:[self PASSCODE_IDENTIFIER]];
  BOOL isMatch = [aMatchPassword isEqualToString:storedPassCode];
  return isMatch;
}

- (BOOL)isPassCodeEntered
{
  NSData *passwordData = [self searchKeychainDataCopyMatching:[self PASSCODE_IDENTIFIER]];
  return passwordData != nil;
}

- (BOOL)unlocked
{
  return ![self isPassCodeEntered] || [self isUnlocked];
}

- (BOOL)unlockWithPassCode:(NSString *)aPass
{
  BOOL isPassesMatch = [self isPasswordMatchWithStored:aPass];
  if (isPassesMatch) {
    [self setIsUnlocked:YES];
  }
  return isPassesMatch;
}

- (void)lock
{
  [self setIsUnlocked:NO];
}

- (void)unlock
{
  [self setIsUnlocked:YES];
}

#pragma mark Keychain service support

- (NSMutableDictionary *)newQueryForIdentifier:(NSString *)identifier
{
  NSMutableDictionary *searchDictionary = [[NSMutableDictionary alloc] init];
  [searchDictionary setObject:(__bridge id) kSecClassGenericPassword forKey:(__bridge id) kSecClass];
  NSData *encodedIdentifier = [identifier dataUsingEncoding:NSUTF8StringEncoding];
  [searchDictionary setObject:encodedIdentifier forKey:(__bridge id) kSecAttrGeneric];
  [searchDictionary setObject:encodedIdentifier forKey:(__bridge id) kSecAttrAccount];
  [searchDictionary setObject:[self serviceName] forKey:(__bridge id) kSecAttrService];

  return searchDictionary;
}

- (NSData *)searchKeychainDataCopyMatching:(NSString *)identifier
{
  NSMutableDictionary *searchDictionary = [self newQueryForIdentifier:identifier];

  // Add search attributes
  [searchDictionary setObject:(__bridge id) kSecMatchLimitOne forKey:(__bridge id) kSecMatchLimit];

  // Add search return types
  [searchDictionary setObject:(id) kCFBooleanTrue forKey:(__bridge id) kSecReturnData];

  CFDataRef result = nil;
  SecItemCopyMatching((__bridge CFDictionaryRef) searchDictionary, (CFTypeRef *) &result);

  return CFBridgingRelease(result);
}

- (id<NSCoding>)searchKeychainValueCopyMatching:(NSString *)identifier
{
  NSData *data = [self searchKeychainDataCopyMatching:identifier];
  return [NSKeyedUnarchiver unarchiveObjectWithData:data];
}

- (BOOL)setKeychainValue:(id <NSCoding>)value forIdentifier:(NSString *)identified
{
  NSData *currentData = [self searchKeychainDataCopyMatching:identified];

  if (!currentData) {
    return [self createKeychainValue:value forIdentifier:identified];
  }
  else {
    return [self updateKeychainValue:value forIdentifier:identified];
  }
}

- (BOOL)createKeychainValue:(id <NSCoding>)value
              forIdentifier:(NSString *)identifier
{
  NSMutableDictionary *query = [self newQueryForIdentifier:identifier];

  NSData *valueData = [NSKeyedArchiver archivedDataWithRootObject:value];
  [query setObject:valueData forKey:(__bridge id) kSecValueData];

  OSStatus status = SecItemAdd((__bridge CFDictionaryRef) query, NULL);

  if (status == errSecSuccess) {
    return YES;
  }

  return NO;
}

- (BOOL)updateKeychainValue:(id <NSCoding>)value
              forIdentifier:(NSString *)identifier
{
  NSMutableDictionary *query = [self newQueryForIdentifier:identifier];
  NSMutableDictionary *updateQuery = [[NSMutableDictionary alloc] init];
  NSData *valueData = [NSKeyedArchiver archivedDataWithRootObject:value];
  [updateQuery setObject:valueData forKey:(__bridge id) kSecValueData];

  OSStatus status = SecItemUpdate((__bridge CFDictionaryRef) query, (__bridge CFDictionaryRef) updateQuery);

  if (status == errSecSuccess) {
    return YES;
  }

  return NO;
}

- (void)deleteKeychainValue:(NSString *)identifier
{
  NSMutableDictionary *query = [self newQueryForIdentifier:identifier];
  SecItemDelete((__bridge CFDictionaryRef) query);
}

#pragma mark - TouchID
- (BOOL)isTouchIDAvailable
{
  LAContext *context = [LAContext new];
  return [context canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:nil];
}

- (BOOL)isTouchIDLockEnabled
{
  NSNumber *touchIDEnabled = (NSNumber *)[self searchKeychainValueCopyMatching:[self TOUCH_ID_ENABLED_IDENTIFIER]];
  return [touchIDEnabled boolValue];
}

- (void)setIsTouchIDLockEnabled:(BOOL)enabled
{
  [self setKeychainValue:@(enabled) forIdentifier:[self TOUCH_ID_ENABLED_IDENTIFIER]];
}

- (BOOL)isCancelCode:(NSError *)error
{
  NSInteger errorCode = error.code;
  return (errorCode == LAErrorUserCancel ||
          errorCode == LAErrorSystemCancel ||
          errorCode == LAErrorAuthenticationFailed ||
          errorCode == LAErrorUserFallback);
}

- (void)enabledTouchIDWithCompletion:(ds_completion_handler)completion
{
  const BOOL touchIDAvailable = [self isTouchIDAvailable];
  [self setIsTouchIDLockEnabled:touchIDAvailable];
  completion(touchIDAvailable, NO_MESSAGE);
}

- (void)unlockUsingTouchIDWithCompletion:(ds_completion_handler)completion
{
  if (![self isTouchIDLockEnabled]) {
    completion(FAILED_WITH_MESSAGE, NO_MESSAGE);
    return;
  }
  
  LAContext *context = [LAContext new];
  context.localizedFallbackTitle = NSLocalizedString(@"Enter Passcode", nil);

  [context evaluatePolicy:_policy
          localizedReason:NSLocalizedString(@"settings.unlockFlipDrive", nil)
                    reply:^(BOOL success, NSError *error) {
                      dispatch_async(dispatch_get_main_queue(), ^{
                        if (success) {
                          [self unlock];
                          completion(SUCCEED_WITH_MESSAGE, NO_MESSAGE);
                        }
                        else {
                          DSMessage *errorMessage = nil;
                          if (![self isCancelCode:error]) {
                            errorMessage = [DSMessage messageWithError:error];
                          }
                          completion(FAILED_WITH_MESSAGE, errorMessage);
                        }
                      });
                    }];
}

- (void)disableTouchID
{
  [self setKeychainValue:@(false) forIdentifier:[self TOUCH_ID_ENABLED_IDENTIFIER]];
}

@end
