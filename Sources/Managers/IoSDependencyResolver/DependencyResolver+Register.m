
#import "DependencyResolver+Register.h"
#import "DependencyResolver+Private.h"


@implementation DependencyResolver (Register)
+ (void)addClass:(Class)theConcreteClass
     forProtocol:(Protocol *)theProtocol {  
  DependencyResolver *instance = [self sharedInstance];
  NSValue *protocolObject = [NSValue valueWithPointer:( const void *)(theProtocol)];
  [[instance resolveMap] setObject:theConcreteClass
                            forKey:protocolObject];

}

@end
