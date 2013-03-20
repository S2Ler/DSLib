
#import "UITableView+DSAdditions.h"


@implementation UITableView (DSAdditions)
- (void)deselectAllRows
{
  [self deselectAllRowsAnimated:YES];
}

- (void)deselectAllRowsAnimated:(BOOL)animated
{
  [[self indexPathsForSelectedRows] enumerateObjectsUsingBlock:^(NSIndexPath *cellPath, NSUInteger idx, BOOL *stop)
  {
    [self deselectRowAtIndexPath:cellPath animated:animated];
  }];
}


@end
