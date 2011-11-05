
#import <Foundation/Foundation.h>

@class PGAlertMessage;

@interface PGAlertsHandler : NSObject
+ (PGAlertsHandler *)sharedInstance;
- (void)showAlertWithMessage:(PGAlertMessage *)theMessage;
@end
