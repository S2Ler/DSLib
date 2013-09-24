
#import <Foundation/Foundation.h>


@interface DependencyResolver : NSObject {
  NSMutableDictionary *_resolveMap;
  NSMutableDictionary *_singletonsCache;
}

+ (Class)resolve:(Protocol *)theProtocol;
+ (Class)resolveWithName:(NSString *)theProtocolName;

+ (id)resolveSingleton:(Protocol *)theProtocol;
+ (id)resolveSingletonWithName:(NSString *)theProtocolName;

@end
