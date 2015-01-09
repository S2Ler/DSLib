
@import Foundation;

@interface DSFakeWebServiceRequestBehaviour : NSObject
- (id)initWithDefinition:(NSDictionary *)theBehaviourDefinition;
- (BOOL)shouldFail;
- (NSString *)errorMessage;
@end
