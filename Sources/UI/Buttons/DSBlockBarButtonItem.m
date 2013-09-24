
#import "DSBlockBarButtonItem.h"


@implementation DSBlockBarButtonItem
- (id)initWithBarButtonSystemItem:(UIBarButtonSystemItem)systemItem
{
  return [self initWithBarButtonSystemItem:systemItem
                                    target:nil
                                    action:nil];

}

- (void)setActionBlock:(ds_action_block_t)actionBlock
{
  _actionBlock = actionBlock;
  [self setTarget:self];
  [self setAction:@selector(executeActionBlock)];
}

- (void)executeActionBlock
{
  if ([self actionBlock]) {
    [self actionBlock](self);
  }
}

@end
