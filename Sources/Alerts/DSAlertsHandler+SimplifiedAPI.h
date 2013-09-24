
#import <Foundation/Foundation.h>
#import "DSAlertsHandler.h"

@class DSMessage;

@interface DSAlertsHandler (SimplifiedAPI)
- (void)showSimpleMessageAlert:(DSMessage *)theMessage;
@end
