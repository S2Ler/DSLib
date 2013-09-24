
#pragma mark - include
#import "DSAlertViewFactory.h"
#import "DSAlertView.h"
#import "DSAlert.h"
#import "DSUIAlertView.h"
#import "DSAlertViewDelegate.h"
#import "DSAlertButton.h"
#import "DSAlertsHandlerConfiguration.h"


@implementation DSAlertViewFactory

+ (id<DSAlertView>)modalAlertViewWithAlert:(DSAlert *)theAlert
                                  delegate:(id<DSAlertViewDelegate>)theDelegate
{
  NSArray *otherButtons = [theAlert otherButtons];

  NSMutableArray *otherButtonsTitles = [NSMutableArray array];
  for (DSAlertButton *button in otherButtons) {
    [otherButtonsTitles addObject:[button title]];
  }

  id<DSAlertView> alertView = nil;
  NSString *alertViewClassName = [[DSAlertsHandlerConfiguration sharedInstance] modelAlertsClassName];
  Class alertViewClass = NSClassFromString(alertViewClassName);
  if (alertViewClass) {
    alertView = [[alertViewClass alloc] initWithTitle:[theAlert localizedTitle]
                                              message:[theAlert localizedBody]
                                             delegate:theDelegate
                                    cancelButtonTitle:[[theAlert cancelButton] title]
                                          otherTitles:otherButtonsTitles];
  }
  else {
    alertView
      = [[DSUIAlertView alloc] initWithTitle:[theAlert localizedTitle]
                                     message:[theAlert localizedBody]
                                    delegate:theDelegate
                           cancelButtonTitle:[[theAlert cancelButton] title]
                                 otherTitles:otherButtonsTitles];
  }

  return alertView;
}


@end
