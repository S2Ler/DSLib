
@import Foundation;

@class DSMessage;
@class DSAlertButton;


@interface DSAlert: NSObject

@property (nonatomic, strong, readonly) DSAlertButton *cancelButton;
@property (nonatomic, strong, readonly) NSArray *otherButtons;
@property (nonatomic, strong, readonly) DSMessage *message;

/** Default is YES */
@property (nonatomic, assign) BOOL shouldDismissOnApplicationDidResignActive;

- (id)initWithMessage:(DSMessage *)theMessage
         cancelButton:(DSAlertButton *)theCancelButton
         otherButtons:(DSAlertButton *)theButtons, ... NS_REQUIRES_NIL_TERMINATION;

- (NSString *)localizedTitle;
- (NSString *)localizedBody;

- (BOOL)isAlertMessageEqualWith:(id)theObj;

@end
