
#import <Foundation/Foundation.h>

@protocol DSArrayChangeApplier <NSObject>
- (void)applyChanges:(NSArray *)changes completion:(void (^)(BOOL finished))completion;
@end
