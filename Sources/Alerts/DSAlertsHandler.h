
#import <Foundation/Foundation.h>
#import "DSAlertViewDelegate.h"

@class DSAlert;
@class Reachability;

#define DSAlertsHandler_SHOW_NO_INTERNET_CONNECTION_POPUPS_ONCE 0

@interface DSAlertsHandler: NSObject<DSAlertViewDelegate>

@property (nonatomic, weak) Reachability *reachability;

+ (id)sharedInstance;

- (void)showAlert:(DSAlert *)theAlert modally:(BOOL)isModalAlert;
@end
