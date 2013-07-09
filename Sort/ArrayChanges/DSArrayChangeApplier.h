//
//  DSArrayChangeApplier
//  uPrintX
//
//  Created by Alexander Belyavskiy on 6/3/13.

#import <Foundation/Foundation.h>

@protocol DSArrayChangeApplier <NSObject>
- (void)applyChanges:(NSArray *)changes completion:(void (^)(BOOL finished))completion;
@end
