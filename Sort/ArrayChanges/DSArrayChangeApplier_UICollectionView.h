
@import Foundation;
#import "DSArrayChangeApplier.h"
@import UIKit;

/** Only 1 section collection views are supported */
NS_CLASS_AVAILABLE_IOS(6_0) @interface DSArrayChangeApplier_UICollectionView : NSObject<DSArrayChangeApplier>
/**
* @param collectionView is weak reference
*/
- (id)initWithCollectionView:(UICollectionView *)collectionView ;
@end
