
#import <Foundation/Foundation.h>

@protocol DSPassCodeControllerDelegate;

@interface DSPassCodeController: NSObject

@property (nonatomic, assign) NSTimeInterval lockTimeInterval;
@property (nonatomic, strong) NSString *uniqueID;
@property (nonatomic, weak) id<DSPassCodeControllerDelegate> delegate;

/** Store aPass to secure storage */
- (void)storePassword:(NSString *)aPass;

/** Compare aMatchPassword with saved in secure storage */
- (BOOL)isPasswordMatchWithStored:(NSString *)aMatchPassword;

/** \return YES if user enter passCode in the settings */
- (BOOL)isPassCodeEntered;

/** \return YES if PassCodeStorage was unlocked with unlockWithPassword: or unlock selectors or there is no stored passcode */
- (BOOL)unlocked;

- (void)lockIfNeeded;

/** unlock PassCodeStorage if aPass is equal to stored in the secure storage */
- (void)unlockWithPassCode:(NSString *)aPass;

@end
