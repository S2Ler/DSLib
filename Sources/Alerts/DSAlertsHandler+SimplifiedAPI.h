
#import <Foundation/Foundation.h>
#import "DSAlertsHandler.h"

@class DSMessage;

@interface DSAlertsHandler (SimplifiedAPI)
- (void)showSimpleMessageAlert:(DSMessage *)theMessage;
- (void)showError:(NSError *)error;
- (void)showParseError:(NSError *)error;
- (void)showUnknownError;
@end
