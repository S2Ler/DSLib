
#import "DSMessage.h"
#import "DSAlert.h"
#import "DSAlertButton.h"
#import "DSAlertsHandler+SimplifiedAPI.h"



@implementation DSAlertsHandler (SimplifiedAPI)
- (void)showSimpleMessageAlert:(DSMessage *)theMessage
{
  DSAlert *alert = [[DSAlert alloc]
    initWithMessage:theMessage
       cancelButton:[DSAlertButton OKButton]
       otherButtons:nil];
  [self showAlert:alert modally:YES];
}

@end
