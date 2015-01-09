
@import Foundation;
#import "DSAlertsHandler.h"

@class DSMessage;


@protocol DSAlertsHandlerSimplifiedAPIDelegate <NSObject>
/**
 @return you may return nil, then default alert will be created.
 */
- (DSAlert *)customAlertForGeneralError:(DSMessage *)generalErrorMessage;

@optional
- (DSAlert *)customAlertMessage:(DSMessage *)message;
@end

@interface DSAlertsHandler (SimplifiedAPI)
- (void)setSimpleAPIDelegate:(id<DSAlertsHandlerSimplifiedAPIDelegate>)simplifiedAPIDelegate;
- (void)showSimpleMessageAlert:(DSMessage *)theMessage;
- (void)showError:(NSError *)error;
- (void)showParseError:(NSError *)error;
- (void)showUnknownError;
@end
