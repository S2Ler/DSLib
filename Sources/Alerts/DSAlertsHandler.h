
@import Foundation;
#import "DSAlertViewDelegate.h"

@class DSAlert;
@class DSReachability;
@class DSAlertsQueue;

//Deprecated in favour of DSAlertsHandlerConfiguration showOfflineErrorsMoveThanOncen
//#define DSAlertsHandler_SHOW_NO_INTERNET_CONNECTION_POPUPS_ONCE 1

@interface DSAlertsHandler: NSObject<DSAlertViewDelegate>

@property (nonatomic, weak) DSReachability *reachability;
@property (nonatomic, strong) NSArray *filterOutMessages;

+ (instancetype)sharedInstance;

- (void)showAlert:(DSAlert *)theAlert modally:(BOOL)isModalAlert;

- (DSAlertsQueue *)detachAlertsQueue;

@end
