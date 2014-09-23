
#import "DSMessage.h"
#import "DSAlert.h"
#import "DSAlertButton.h"
#import "DSAlertsHandler+SimplifiedAPI.h"
#import "NSError+Parse.h"
#import <objc/runtime.h>

@implementation DSAlertsHandler (SimplifiedAPI)
static char simplifiedAPIDelegateKey;

- (void)setSimpleAPIDelegate:(id<DSAlertsHandlerSimplifiedAPIDelegate>)simplifiedAPIDelegate
{
  objc_setAssociatedObject(self, &simplifiedAPIDelegateKey, simplifiedAPIDelegate, OBJC_ASSOCIATION_ASSIGN);
}

- (id<DSAlertsHandlerSimplifiedAPIDelegate>)simpleAPIDelegate
{
  return objc_getAssociatedObject(self, &simplifiedAPIDelegateKey);
}

- (void)showSimpleMessageAlert:(DSMessage *)theMessage
{
  DSAlert *alert = nil;
  
  if ([theMessage isGeneralErrorMessage]) {
    alert = [[self simpleAPIDelegate] customAlertForGeneralError:theMessage];
  }
  else if ([[self simpleAPIDelegate] respondsToSelector:@selector(customAlertMessage:)]){
    alert = [[self simpleAPIDelegate] customAlertMessage:theMessage];
  }
  
  if (!alert) {
    alert = [[DSAlert alloc] initWithMessage:theMessage
                                cancelButton:[DSAlertButton OKButton]
                                otherButtons:nil];
  }
  
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
