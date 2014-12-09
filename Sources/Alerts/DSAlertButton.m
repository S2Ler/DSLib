
#pragma mark - include
#import "DSAlertButton.h"

typedef enum
{
  OAlertButtonTargetActionInvocationType = 100,
  OAlertButtonBlockInvocationType
} OAlertButtonInvocationType;

#pragma mark - private
@interface DSAlertButton ()
@property (nonatomic, strong) NSString *title;
@property (nonatomic, weak) id target;
@property (nonatomic, assign) SEL action;
@property (nonatomic, copy) ds_action_block_t block;
@property (nonatomic, assign) OAlertButtonInvocationType invocationType;
@end

@implementation DSAlertButton

- (instancetype)initWithTitle:(NSString *)theTitle target:(id)theTarget action:(SEL)theAction
{
  self = [super init];
  if (self) {
    _title = [theTitle copy];
    _target = theTarget;
    _action = theAction;
    _invocationType = OAlertButtonTargetActionInvocationType;
  }
  
  return self;
}

+ (instancetype)buttonWithTitle:(NSString *)theTitle target:(id)theTarget action:(SEL)theAction
{
  DSAlertButton *button = [[DSAlertButton alloc] initWithTitle:theTitle
                                                        target:theTarget
                                                        action:theAction];
  return button;
}


- (instancetype)initWithTitle:(NSString *)theTitle
              invocationBlock:(ds_action_block_t)theBlock
{
  self = [super init];
  if (self) {
    _title = [theTitle copy];
    _block = theBlock;
    _invocationType = OAlertButtonBlockInvocationType;
  }
  
  return self;
}


+ (instancetype)buttonWithTitle:(NSString *)theTitle invocationBlock:(ds_action_block_t)theBlock
{
  DSAlertButton *button = [[DSAlertButton alloc] initWithTitle:theTitle
                                               invocationBlock:theBlock];
  return button;
}

- (void)invoke
{
  if ([self invocationType] == OAlertButtonBlockInvocationType && [self block] != NULL) {
    [self block](self);
  }
  else if ([self invocationType] == OAlertButtonTargetActionInvocationType) {
    if ([[self target] respondsToSelector:[self action]] == YES) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
      [[self target] performSelector:[self action]];
#pragma clang diagnostic pop
    }
  }
}

@end

@implementation DSAlertButton (FactoryMethods)
+ (instancetype)cancelButton
{
  return [self cancelButtonWithBlock:nil];
}

+ (instancetype)cancelButtonWithBlock:(ds_action_block_t)block
{
  DSAlertButton *button = [DSAlertButton buttonWithTitle:NSLocalizedString(@"Cancel", nil)
                                         invocationBlock:block];
  return button;
}

+ (instancetype)NOButton
{
  DSAlertButton *button = [DSAlertButton buttonWithTitle:NSLocalizedString(@"NO", nil)
                                         invocationBlock:NULL];
  return button;
}

+ (instancetype)OKButton
{
  DSAlertButton *button = [DSAlertButton buttonWithTitle:NSLocalizedString(@"OK", nil)
                                         invocationBlock:NULL];
  return button;
}
@end
