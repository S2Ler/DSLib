
#import "DSArrayChangeApplier_UICollectionView.h"
#import "DSArrayChange.h"


@interface DSArrayChangeApplier_UICollectionView()
@property (nonatomic, weak) UICollectionView *collectionView;
@end

@implementation DSArrayChangeApplier_UICollectionView
- (id)initWithCollectionView:(UICollectionView *)collectionView {
    self = [super init];
    if (self) {
        _collectionView = collectionView;
    }
    return self;
}


- (void)applyChanges:(NSArray *)changes completion:(void (^)(BOOL finished))completion {
    if ([changes count] == 0) {
        if (completion) {
            completion(YES);
        }
        return;
    }
    
    [[self collectionView] performBatchUpdates:^{
        for (DSArrayChange *change in changes) {
            switch ([change type]) {

                case DSArrayChangeTypeMove: {
                    [[self collectionView] moveItemAtIndexPath:[NSIndexPath indexPathForItem:[change index]
                                                                                   inSection:0]
                                                   toIndexPath:[NSIndexPath indexPathForItem:[change toIndex]
                                                                                   inSection:0]];
                }
                    break;
                case DSArrayChangeTypeUpdate: {
                    [[self collectionView] reloadItemsAtIndexPaths:@[[NSIndexPath indexPathForItem:[change index]
                                                                                         inSection:0]]];
                }
                    break;
                case DSArrayChangeTypeRemove: {
                    [[self collectionView] deleteItemsAtIndexPaths:@[[NSIndexPath indexPathForItem:[change index]
                                                                                         inSection:0]]];
                }
                    break;
                case DSArrayChangeTypeInsert: {
                    [[self collectionView] insertItemsAtIndexPaths:@[[NSIndexPath indexPathForItem:[change index]
                                                                                         inSection:0]]];
                }
                    break;
            }
        }
    }
                                    completion:completion];
}

@end
