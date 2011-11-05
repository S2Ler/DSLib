
#import "UISwitch+DSCheckButton.h"
/** Provide the same behavior as DSCheckButton */
@implementation UISwitch (DSCheckButton)

- (BOOL)isChecked
{
  return [self isOn];
}

- (void)setChecked:(BOOL)theFlag
{
  BOOL currentCheckedValue = [self isChecked];
  
  if (currentCheckedValue != theFlag) {
    [self willChangeValueForKey:@"isChecked"];
  }
  
  [self setOn:theFlag
     animated:NO];
  
  if (currentCheckedValue != theFlag) {
    [self didChangeValueForKey:@"isChecked"];
  }
}

- (id<DSCheckButtonProtocol>)checkButtonProtocol
{
  return (id<DSCheckButtonProtocol>)self;
}
@end
