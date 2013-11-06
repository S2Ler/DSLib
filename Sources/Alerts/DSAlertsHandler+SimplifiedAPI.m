
#import "DSMessage.h"
#import "DSAlert.h"
#import "DSAlertButton.h"
#import "DSAlertsHandler+SimplifiedAPI.h"
#import "NSError+Parse.h"


@implementation DSAlertsHandler (SimplifiedAPI)
- (void)showSimpleMessageAlert:(DSMessage *)theMessage
{
  DSAlert *alert = [[DSAlert alloc]
    initWithMessage:theMessage
       cancelButton:[DSAlertButton OKButton]
       otherButtons:nil];
  [self showAlert:alert modally:YES];
}

- (void)showError:(NSError *)error
{
  if (error) {
    [self showSimpleMessageAlert:[DSMessage messageWithError:error]];
  }
  else {
    [self showSimpleMessageAlert:[DSMessage unknownError]];
  }
}

- (void)showParseError:(NSError *)error
{
  if ([error code] == 120) {return;}//miss cache error - we don't need it
  
  [self showError:[error correctedParseError]];
}

- (void)showUnknownError
{
  [self showError:nil];
}

@end
