#import "DSFetchedResultsControllerDelegate.h"

@implementation DSFetchedResultsControllerDelegate
@synthesize delegate = _delegate;

- (id)initWithTableViewController:(id <DSConfigurableTableController>)controller
{
  self = [super init];
  if (self) {
    _delegate = controller;
  }
  return self;
}

- (UITableView *)tableView
{
  return [[self delegate] tableView];
}

#pragma mark - Fetched results controller delegate
- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller
{
  [[self tableView] beginUpdates];
  
  if ([[self delegate] respondsToSelector:@selector(fetchDelegateStartedUpdateTable:)]) {
    [[self delegate] fetchDelegateStartedUpdateTable:self];
  }
}

- (void)controller:(NSFetchedResultsController *)controller
  didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo
           atIndex:(NSUInteger)sectionIndex
     forChangeType:(NSFetchedResultsChangeType)type
{
  switch (type) {
    case NSFetchedResultsChangeInsert: {
      [[self tableView]
       insertSections:[NSIndexSet indexSetWithIndex:sectionIndex]
       withRowAnimation:UITableViewRowAnimationFade];
    }
      break;
    case NSFetchedResultsChangeDelete: {
      [[self tableView]
       deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex]
       withRowAnimation:UITableViewRowAnimationFade];
    }
      break;
    default:
      break;
  }
}

- (void)controller:(NSFetchedResultsController *)controller
   didChangeObject:(id)anObject
       atIndexPath:(NSIndexPath *)indexPath
     forChangeType:(NSFetchedResultsChangeType)type
      newIndexPath:(NSIndexPath *)newIndexPath
{
  switch (type) {
    case NSFetchedResultsChangeInsert: {
      NSIndexPath *updatedPath = newIndexPath;
      if (updatedPath == nil) {
        updatedPath = indexPath;
      }
      
      [[self tableView]
       insertRowsAtIndexPaths:[NSArray arrayWithObject:updatedPath]
       withRowAnimation:UITableViewRowAnimationFade];
      
      if ([[self delegate] respondsToSelector:
           @selector(fetchDelegate:didInsertItemAtIndexPath:)]) {
        [[self delegate] fetchDelegate:self
              didInsertItemAtIndexPath:updatedPath];
      }
    }
      break;
      
    case NSFetchedResultsChangeDelete: {
      NSIndexPath *updatedPath = indexPath;
      if (updatedPath == nil) {
        updatedPath = newIndexPath;
      }
      
      [[self tableView]
       deleteRowsAtIndexPaths:[NSArray arrayWithObject:updatedPath]
       withRowAnimation:UITableViewRowAnimationFade];
      
      if ([[self delegate] respondsToSelector:
           @selector(fetchDelegate:didDeleteItemAtIndexPath:)]) {
        [[self delegate] fetchDelegate:self
              didDeleteItemAtIndexPath:updatedPath];
      }
    }
      break;
      
    case NSFetchedResultsChangeUpdate: {
      NSIndexPath *updatedPath = newIndexPath;
      if (updatedPath == nil) {
        updatedPath = indexPath;
      }
      [[self delegate] updateCellAtIndexPath:updatedPath];
    }
      break;
      
    case NSFetchedResultsChangeMove:
      [[self tableView]
       deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
       withRowAnimation:UITableViewRowAnimationFade];
      [[self tableView] insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath]
                              withRowAnimation:UITableViewRowAnimationFade];
      if ([[self delegate] respondsToSelector:
           @selector(fetchDelegate:didMoveItemFromIndexPath:toIndexPath:)]) {
        [[self delegate] fetchDelegate:self
              didMoveItemFromIndexPath:indexPath
                           toIndexPath:newIndexPath];
      }
      break;
  }
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
  if ([[self delegate] respondsToSelector:@selector(fetchDelegateAboutToEndTableUpdate:)]) {
    [[self delegate] fetchDelegateAboutToEndTableUpdate:self];
  }
  
  [[self tableView] endUpdates];
  
  if ([[self delegate] respondsToSelector:@selector(fetchDelegateEndedTableUpdate:)]) {
    [[self delegate] fetchDelegateEndedTableUpdate:self];
  }
}

@end
