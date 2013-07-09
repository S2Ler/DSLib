//
//  DSArrayChangeApplier_UICollectionView
//  uPrintX
//
//  Created by Alexander Belyavskiy on 6/3/13.

#import <Foundation/Foundation.h>
#import "DSArrayChangeApplier.h"


/** Only 1 section collection views are supported */
@interface DSArrayChangeApplier_UICollectionView : NSObject<DSArrayChangeApplier>
/**
* @param collectionView is weak reference
*/
- (id)initWithCollectionView:(PSUICollectionView *)collectionView;
@end
