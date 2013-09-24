
#import <Foundation/Foundation.h>
#import "DependencyResolver.h"

@interface DependencyResolver (Register)
+ (void)addClass:(Class)theConcreteClass
     forProtocol:(Protocol *)theProtocol;
@end
