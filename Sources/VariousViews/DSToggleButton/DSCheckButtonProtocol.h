
@import Foundation;

@protocol DSCheckButtonProtocol <NSObject>
- (BOOL)isChecked;
- (void)setChecked:(BOOL)theFlag;
- (CGRect)frame;
- (void)setTag:(NSInteger)theTag;
- (NSInteger)tag;
@end
