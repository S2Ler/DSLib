
#import "DSDateFormatterCache.h"
#import "DSMacros.h"

@interface DSDateFormatterCache ()
@property (nonatomic, retain) NSMutableDictionary *cache;
- (void)localeChanged;
@end

@implementation DSDateFormatterCache
@synthesize cache = _cache;

#pragma mark ----------------Singleton----------------
+ (DSDateFormatterCache *)sharedInstance {
	DEFINE_SHARED_INSTANCE_USING_BLOCK(^{
    return [[DSDateFormatterCache alloc] init];
  });
}

- (id) init {
	self = [super init];
	if (self != nil) {		
    _cache = [[NSMutableDictionary alloc] init];
    [[NSNotificationCenter defaultCenter] 
     addObserver:self
     selector:@selector(localeChanged)
     name:NSCurrentLocaleDidChangeNotification
     object:nil];
	}
	return self;
}

#pragma mark - public
+ (void)cacheDateFormatter:(NSDateFormatter *)theDateFormatter
                    forKey:(NSString *)theKey {
  DSDateFormatterCache *cacher = [self sharedInstance];
  NSMutableDictionary *cache = [cacher cache];
  
  if (theDateFormatter && theKey) {
    [cache setObject:theDateFormatter
              forKey:theKey];
  }
}

+ (void)cacheDateFormatter:(NSDateFormatter *)theDateFormatter
                  forClass:(Class)theClass {
  [self cacheDateFormatter:theDateFormatter
                    forKey:NSStringFromClass(theClass)];
}

+ (NSDateFormatter *)dateFormatterForKey:(NSString *)theKey 
{
  if (!theKey)
  {
    return nil;
  }
  
  DSDateFormatterCache *cacher = [self sharedInstance];
  NSMutableDictionary *cache = [cacher cache];

  return [cache objectForKey:theKey];
}

+ (NSDateFormatter *)dateFormatterForClass:(Class)theClass {
  return [self dateFormatterForKey:NSStringFromClass(theClass)];
}

#pragma mark - reinitialization
- (void)localeChanged
{
  for (NSDateFormatter *formatter in [_cache objectEnumerator])
  {
    [formatter setLocale:[NSLocale currentLocale]];
  }
}

@end