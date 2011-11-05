
#import <Foundation/Foundation.h>


@interface DependencyResolver : NSObject {
  NSMutableDictionary *resolveMap_;
}

+ (Class)resolve:(Protocol *)theProtocol;

@end
