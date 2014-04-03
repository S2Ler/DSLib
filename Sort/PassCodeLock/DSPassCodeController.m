#import "DSPassCodeController.h"
#import "DSPassCodeControllerDelegate.h"
#import "NSString+Extras.h"

@interface DSPassCodeController () {
  NSString *_PASSCODE_IDENTIFIER;
}
/** just unlock PassCodeStorage without enter a passCode */
- (void)unlock;

/** lock storage */
- (void)lock;

- (NSMutableDictionary *)newSearchDictionary:(NSString *)identifier;

- (NSData *)searchKeychainCopyMatching:(NSString *)identifier;

- (BOOL)createKeychainValue:(NSString *)password
              forIdentifier:(NSString *)identifier;

- (BOOL)updateKeychainValue:(NSString *)password
              forIdentifier:(NSString *)identifier;

- (void)deleteKeychainValue:(NSString *)identifier;

@property (nonatomic, strong) NSDate *resignActiveDate;

@end

static BOOL isUnlocked_ = NO;

@implementation DSPassCodeController

- (NSString *)PASSCODE_IDENTIFIER
{
  if (!_PASSCODE_IDENTIFIER) {
    _PASSCODE_IDENTIFIER = [NSString stringWithFormat:@"passcode_id:%@", [self uniqueID]];
  }
  return _PASSCODE_IDENTIFIER;
}

- (void)setUniqueID:(NSString *)uniqueID
{
  _PASSCODE_IDENTIFIER = nil;
  _uniqueID = uniqueID;
}

- (void)dealloc
{
  [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)setResignActiveDate:(NSDate *)resignActiveDate
{
  [[NSUserDefaults standardUserDefaults] setObject:resignActiveDate forKey:@"DSPassCodeController_resignTime"];
  [[NSUserDefaults standardUserDefaults] synchronize];
}

- (NSDate *)resignActiveDate
{
  return [[NSUserDefaults standardUserDefaults] objectForKey:@"DSPassCodeController_resignTime"];
}

- (id)init
{
  self = [super init];
  if (self) {
    [[NSNotificationCenter defaultCenter]
                           addObserver:self
                              selector:@selector(applicationDidBecomeActive:)
                                  name:UIApplicationDidBecomeActiveNotification
                                object:nil];
    [[NSNotificationCenter defaultCenter]
                           addObserver:self
                              selector:@selector(applicationWillResignActive:)
                                  name:UIApplicationWillResignActiveNotification
                                object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(applicationWillTerminateNotification:)
                                                 name:UIApplicationWillTerminateNotification
                                               object:nil];
    isUnlocked_ = YES;
  }

  return self;
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
  [self setResignActiveDate:[NSDate date]];
}

- (void)lockIfNeeded
{
  NSTimeInterval applicationWasInactiveForTimeInterval = [[NSDate date] timeIntervalSinceDate:[self resignActiveDate]];
  if ([self isPassCodeEntered] && (![self unlocked] || applicationWasInactiveForTimeInterval > [self lockTimeInterval])) {
    [self lock];
    [[self delegate] passCodeController:self didRequestToLockScreenWithUnlockBlock:^BOOL(NSString *unlockCode)
    {
      if ([self isPasswordMatchWithStored:unlockCode]) {
        [self unlock];
        return YES;
      }
      else{
        [self lock];
        return NO;
      }
    }];
  }
}

- (void)storePassword:(NSString *)aPass
{
  if (aPass && ![aPass isEmpty]) {
    NSData *passwordData = [self searchKeychainCopyMatching:[self PASSCODE_IDENTIFIER]];
    if (passwordData) {
      [self updateKeychainValue:aPass forIdentifier:[self PASSCODE_IDENTIFIER]];
    }
    else {
      [self createKeychainValue:aPass forIdentifier:[self PASSCODE_IDENTIFIER]];
    }
  }
  else {
    [self deleteKeychainValue:[self PASSCODE_IDENTIFIER]];
  }
  isUnlocked_ = YES;
}

- (BOOL)isPasswordMatchWithStored:(NSString *)aMatchPassword
{
  NSData *passwordData = [self searchKeychainCopyMatching:[self PASSCODE_IDENTIFIER]];
  NSString *storedPassCode = [[NSString alloc] initWithData:passwordData encoding:NSUTF8StringEncoding];
  BOOL isMatch = [aMatchPassword isEqualToString:storedPassCode];
  return isMatch;
}

- (BOOL)isPassCodeEntered
{
  NSData *passwordData = [self searchKeychainCopyMatching:[self PASSCODE_IDENTIFIER]];
  return passwordData != nil;
}

- (BOOL)unlocked
{
  return ([self isPassCodeEntered] == NO) || (isUnlocked_ == YES);
}

- (void)unlockWithPassCode:(NSString *)aPass
{
  BOOL isPassesMatch = [self isPasswordMatchWithStored:aPass];
  if (isPassesMatch) {
    isUnlocked_ = YES;
  }
}

- (void)lock
{
  isUnlocked_ = NO;
}

- (void)unlock
{
  isUnlocked_ = YES;
}

#pragma mark Keychain service support
static NSString *serviceName = @"RapidRecruitApp";

- (NSMutableDictionary *)newSearchDictionary:(NSString *)identifier
{
  NSMutableDictionary *searchDictionary = [[NSMutableDictionary alloc] init];
  [searchDictionary setObject:(__bridge id)kSecClassGenericPassword forKey:(__bridge id)kSecClass];
  NSData *encodedIdentifier = [identifier dataUsingEncoding:NSUTF8StringEncoding];
  [searchDictionary setObject:encodedIdentifier forKey:(__bridge id)kSecAttrGeneric];
  [searchDictionary setObject:encodedIdentifier forKey:(__bridge id)kSecAttrAccount];
  [searchDictionary setObject:serviceName forKey:(__bridge id)kSecAttrService];

  return searchDictionary;
}

- (NSData *)searchKeychainCopyMatching:(NSString *)identifier
{
  NSMutableDictionary *searchDictionary = [self newSearchDictionary:identifier];

  // Add search attributes
  [searchDictionary setObject:(__bridge id)kSecMatchLimitOne forKey:(__bridge id)kSecMatchLimit];

  // Add search return types
  [searchDictionary setObject:(id)kCFBooleanTrue forKey:(__bridge id)kSecReturnData];

  CFDataRef result = nil;
  SecItemCopyMatching((__bridge CFDictionaryRef)searchDictionary, (CFTypeRef *)&result);

  return (NSData *)CFBridgingRelease(result);
}

- (BOOL)createKeychainValue:(NSString *)password
              forIdentifier:(NSString *)identifier
{
  NSMutableDictionary *dictionary = [self newSearchDictionary:identifier];

  NSData *passwordData = [password dataUsingEncoding:NSUTF8StringEncoding];
  [dictionary setObject:passwordData forKey:(__bridge id)kSecValueData];

  OSStatus status = SecItemAdd((__bridge CFDictionaryRef)dictionary, NULL);

  if (status == errSecSuccess) {
    return YES;
  }
  return NO;
}

- (BOOL)updateKeychainValue:(NSString *)password
              forIdentifier:(NSString *)identifier
{

  NSMutableDictionary *searchDictionary = [self newSearchDictionary:identifier];
  NSMutableDictionary *updateDictionary = [[NSMutableDictionary alloc] init];
  NSData *passwordData = [password dataUsingEncoding:NSUTF8StringEncoding];
  [updateDictionary setObject:passwordData forKey:(__bridge id)kSecValueData];

  OSStatus
    status = SecItemUpdate((__bridge CFDictionaryRef)searchDictionary, (__bridge CFDictionaryRef)updateDictionary);

  if (status == errSecSuccess) {
    return YES;
  }
  return NO;
}

- (void)deleteKeychainValue:(NSString *)identifier
{
  NSMutableDictionary *searchDictionary = [self newSearchDictionary:identifier];
  SecItemDelete((__bridge CFDictionaryRef)searchDictionary);
}

@end
