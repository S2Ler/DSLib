
@import Foundation;

@protocol DSWebServiceParamsBuilder <NSObject>

@property (nonatomic, strong) NSData *params;

- (void)startParamsOutput;
- (void)startDictionaryLeafWithName:(NSString *)theName;
- (void)startArrayLeafWithName:(NSString *)theName;

- (void)addParamWithKey:(NSString *)theKey value:(NSString *)theValue;

- (void)endLeaf;
- (void)endParamsOutput;

@end
