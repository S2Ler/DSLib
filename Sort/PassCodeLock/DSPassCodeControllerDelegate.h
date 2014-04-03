
@class DSPassCodeController;

/** @return the status of the unlock operation: YES = unlocked, NO = the unlock code is wrong */
typedef BOOL (^unlock_block_t)(NSString *unlockCode);

@protocol DSPassCodeControllerDelegate<NSObject>
- (void)           passCodeController:(DSPassCodeController *)passCodeController
didRequestToLockScreenWithUnlockBlock:(unlock_block_t)unlockBlock;
@end
