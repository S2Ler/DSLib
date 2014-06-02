

#import <UIKit/UIKit.h>
@import CoreData;

@interface UICollectionView (NSFetchedResultsController)
- (void)addChangeForSection:(id <NSFetchedResultsSectionInfo>)sectionInfo
                    atIndex:(NSUInteger)sectionIndex
              forChangeType:(NSFetchedResultsChangeType)type;
- (void)addChangeForObjectAtIndexPath:(NSIndexPath *)indexPath
                        forChangeType:(NSFetchedResultsChangeType)type
                         newIndexPath:(NSIndexPath *)newIndexPath;
- (void)commitChanges;
@end
