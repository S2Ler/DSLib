
#import "DSFakeWebServiceRequestBehaviour.h"

@interface DSFakeWebServiceRequestBehaviour()
@property (nonatomic, strong) NSDictionary *behaviourDefinition;
@end

@implementation DSFakeWebServiceRequestBehaviour
@synthesize behaviourDefinition = _behaviourDefinition;

- (id)initWithDefinition:(NSDictionary *)theBehaviourDefinition
{
  self = [super init];
  if (self) {
    
  }
  return self;
}

- (BOOL)shouldFail
{
  return [[[self behaviourDefinition] objectForKey:@"should_fail"] boolValue];
}

- (NSString *)errorMessage
{
  return [[self behaviourDefinition] objectForKey:@"error_message"];
}
@end
