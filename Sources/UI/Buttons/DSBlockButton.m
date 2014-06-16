
#pragma mark - include
#import "DSBlockButton.h"

@interface DSBlockButton ()
@property (nonatomic, copy) ds_action_block_t actionBlock;
@end

@implementation DSBlockButton
- (void)setActionBlock:(ds_action_block_t)actionBlock
{
  _actionBlock = actionBlock;
  [self addTarget:self action:@selector(executeActionBlock) forControlEvents:UIControlEventTouchUpInside];
}

- (void)executeActionBlock
{
  if ([self actionBlock]) {
    [self actionBlock](self);
  }
}

@end
