
#pragma mark - include
#import "PGAlertMessage.h"

#pragma mark - Private
@interface PGAlertMessage() {
  NSString *_title;
  NSString *_message;
}
@end

@implementation PGAlertMessage
#pragma mark - synth
@synthesize title = _title;
@synthesize message = _message;

#pragma mark - memory
- (void)dealloc {
  PG_SAVE_RELEASE(_title);
  PG_SAVE_RELEASE(_message);
  
  [super dealloc];    
}

#pragma mark - init
- (id)initWithTitle:(NSString *)theTitle
            message:(NSString *)theMessage {
  self = [super init];
  
  if (self) {
    _title = [theTitle retain];
    _message = [theMessage retain];
  }
  
  return self;
}

+ (PGAlertMessage *)messageWithTitle:(NSString *)theTitle
                             message:(NSString *)theMessage
{
  PGAlertMessage *alertMessage = [[PGAlertMessage alloc]
                                  initWithTitle:theTitle
                                  message:theMessage];
  return [alertMessage autorelease];
}

@end