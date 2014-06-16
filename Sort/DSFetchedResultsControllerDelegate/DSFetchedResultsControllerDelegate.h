
#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class DSFetchedResultsControllerDelegate;

@protocol DSConfigurableTableController <NSObject>
- (void)updateCellAtIndexPath:(NSIndexPath *)indexPath;

- (UITableView *)tableView;

@optional
- (void)   fetchDelegate:(DSFetchedResultsControllerDelegate *)theDelegate
didDeleteItemAtIndexPath:(NSIndexPath *)theIndexPath;

- (void)   fetchDelegate:(DSFetchedResultsControllerDelegate *)theDelegate
didMoveItemFromIndexPath:(NSIndexPath *)theOldIndexPath
             toIndexPath:(NSIndexPath *)theNewIndexPath;

- (void)   fetchDelegate:(DSFetchedResultsControllerDelegate *)theDelegate
didInsertItemAtIndexPath:(NSIndexPath *)theIndexPath;

- (void)fetchDelegateStartedUpdateTable:(DSFetchedResultsControllerDelegate *)theDelegate;
- (void)fetchDelegateAboutToEndTableUpdate:(DSFetchedResultsControllerDelegate *)theDelegate;
- (void)fetchDelegateEndedTableUpdate:(DSFetchedResultsControllerDelegate *)theDelegate;

@end

@interface DSFetchedResultsControllerDelegate : NSObject
  <
  NSFetchedResultsControllerDelegate
  >
{

}

@property (weak, nonatomic) id<DSConfigurableTableController> delegate;

- (id)initWithTableViewController:(id<DSConfigurableTableController>)controller;

@end
