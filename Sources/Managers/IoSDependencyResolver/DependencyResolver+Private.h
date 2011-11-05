
#import <Foundation/Foundation.h>
#import "DependencyResolver.h"

@interface DependencyResolver (Private)
+ (DependencyResolver *)sharedInstance;
@end

@interface DependencyResolver()
@property (nonatomic, retain) NSMutableDictionary *resolveMap;
@end
