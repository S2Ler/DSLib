
#pragma mark - include
#import "DependencyResolver+Private.h"

Protocol *protocolForName(NSString *name);
Protocol *protocolForName(NSString *name) {
    Protocol *protocol = NSProtocolFromString(name);
    return protocol;
}


static DependencyResolver *sharedInstance = nil;

@implementation DependencyResolver
#pragma mark - synth
@synthesize resolveMap = _resolveMap;
@synthesize singletonsCache = _singletonsCache;

#pragma mark - singleton
+ (DependencyResolver *)sharedInstance {
	@synchronized(self) {
		if (sharedInstance == nil) {
			sharedInstance = [[DependencyResolver alloc] init];
		}
	}
	return sharedInstance;
}

+ (id)allocWithZone:(NSZone *)zone {
	@synchronized(self) {
		if (sharedInstance == nil) {
			sharedInstance = [super allocWithZone:zone];
			return sharedInstance;
		}
	}
	
	return nil;
}

- (id)init {
	self = [super init];
	if (self != nil) {		
    _resolveMap = [[NSMutableDictionary alloc] init];
    _singletonsCache = [[NSMutableDictionary alloc] init];
	}
	return self;
}

- (void)dealloc {
  
  abort();
}

#pragma mark - public
+ (Class)resolve:(Protocol *)theProtocol 
{
  @synchronized(self) {
    DependencyResolver *instance = [self sharedInstance];
    NSValue *protocolObject = [NSValue valueWithPointer:( const void *)(theProtocol)];
    Class class = [[instance resolveMap] objectForKey:protocolObject];

    return class;                                
  }
}

+ (Class)resolveWithName:(NSString *)theProtocolName 
{
  @synchronized(self) {
    return [self resolve:protocolForName(theProtocolName)];
  }
}

+ (id)resolveSingleton:(Protocol *)theProtocol 
{
  @synchronized(self) {
    DependencyResolver *instance = [self sharedInstance];
    NSValue *protocolObject = [NSValue valueWithPointer:( const void *)(theProtocol)];
    
    id cachedSingleton = [[instance singletonsCache]
                          objectForKey:protocolObject];
    
    if (!cachedSingleton) {
      cachedSingleton = [[[self resolve:theProtocol] alloc] init];
      [[instance singletonsCache] setObject:cachedSingleton
                                     forKey:protocolObject];
    }
    
    return cachedSingleton;
  }
}

+ (id)resolveSingletonWithName:(NSString *)theProtocolName 
{ 
  @synchronized(self) {
    return [self resolveSingleton:protocolForName(theProtocolName)];
  }
}
@end
