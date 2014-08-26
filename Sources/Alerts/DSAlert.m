
#pragma mark - include
#import "DSAlert.h"
#import "DSAlertButton.h"
#import "DSMessage.h"

#pragma mark - private
@interface DSAlert ()
@property (nonatomic, strong) DSMessage *message;
@property (nonatomic, strong) DSAlertButton *cancelButton;
@property (nonatomic, strong) NSArray *otherButtons;
@end

@implementation DSAlert

- (id)initWithMessage:(DSMessage *)theMessage
         cancelButton:(DSAlertButton *)theCancelButton
         otherButtons:(DSAlertButton *)theButtons, ...
{
  self = [super init];
  if (self) {
    _message = theMessage;
    _cancelButton = theCancelButton;

    va_list buttonsList;
    va_start(buttonsList, theButtons);

    NSMutableArray *buttons = [NSMutableArray array];
    for (DSAlertButton *button = theButtons;
         button != nil;
         button = va_arg(buttonsList, DSAlertButton *))
    {
      [buttons addObject:button];
    }
    va_end(buttonsList);

    _otherButtons = buttons;
    _shouldDismissOnApplicationDidResignActive = YES;
  }

  return self;
}

- (NSString *)localizedTitle
{
  return [[self message] localizedTitle];
}

- (NSString *)localizedBody
{
  return [[self message] localizedBody];
}

- (BOOL)isAlertMessageEqualWith:(id)theObj
{
  if (theObj == nil || [theObj isKindOfClass:[self class]] == NO) {
    return NO;
  }

  BOOL messagesEquals = [[self message] isEqualToMessage:[theObj message]];
  return messagesEquals;
}


@end
