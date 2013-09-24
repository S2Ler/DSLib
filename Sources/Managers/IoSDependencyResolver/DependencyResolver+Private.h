
#import <Foundation/Foundation.h>
#import "DependencyResolver.h"

@interface DependencyResolver (Private)
+ (DependencyResolver *)sharedInstance;
@end

@interface DependencyResolver()
@property (nonatomic, strong) NSMutableDictionary *resolveMap;
@property (nonatomic, strong) NSMutableDictionary *singletonsCache;
@end
