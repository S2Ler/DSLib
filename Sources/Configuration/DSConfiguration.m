
#import "DSConfiguration.h"
#import "NSString+Encoding.h"
#import "NSString+Extras.h"
#import "DSMacros.h"

static NSDictionary *DSConfiguration_sharedConfiguration = nil;

@interface DSConfiguration()
@property (strong) NSDictionary *configuration;

- (NSString *)keyForConfigurationKey:(NSString *)theConfigurationKey
                              scheme:(NSString *)theScheme;
@end

@implementation DSConfiguration

- (void)dealloc
{
  [self removeObserver:self forKeyPath:@"configurationScheme"];
}

- (NSString *)keyForConfigurationKey:(NSString *)theConfigurationKey
                              scheme:(NSString *)theScheme
{
  NSArray *components = [theConfigurationKey componentsSeparatedByString:@":"];
  if (theScheme == nil && [components count] == 1) {
    return [components objectAtIndex:0];
  }
  else if (theScheme == nil && [components count] == 2) {
    return nil;
  }
  else if ([components count] == 2) {
    return [components objectAtIndex:0];
  }
  return nil;
}

- (void)loadSettingsFromConfiguration:(NSDictionary *)theConfiguration
                               scheme:(NSString *)theScheme
{
  NSString *schemePostfix = nil;
  if (theScheme != nil) {
    schemePostfix = [NSString stringWithFormat:@":%@", theScheme];
  }
  else {
    schemePostfix = nil;
  }

  [theConfiguration
    enumerateKeysAndObjectsUsingBlock:^(NSString *configKey, id obj, BOOL *stop)
    {
      if ([configKey containsString:schemePostfix] == YES || schemePostfix == nil) {
        NSString *key = [self keyForConfigurationKey:configKey scheme:schemePostfix];
        if (key != nil) {
          NSString *keySelectorString = [NSString stringWithFormat:@"set%@:", [key stringWithFirstCharUpperCase]];
          if ([self respondsToSelector:NSSelectorFromString(keySelectorString)]) {
            [self setValue:obj forKey:key];
          }
        }
      }
    }];
}

- (id)valueForKey:(NSString *)key
{
  return [[self configuration] valueForKey:key];
}

- (id)valueForKeyPath:(NSString *)keyPath
{
  return [[self configuration] valueForKeyPath:keyPath];
}

- (id)initWithConfiguration:(NSDictionary *)theConfiguration
{
  self = [super init];
  if (self) {
    _configuration = [theConfiguration copy];

    [self loadSettingsFromConfiguration:_configuration scheme:nil];
    [self addObserver:self
           forKeyPath:@"configurationScheme"
              options:NSKeyValueObservingOptionNew
              context:nil];
  }
  return self;

}

+ (id)setupSharedInstanceWithConfigurationDictionary:(NSDictionary *)theConfiguration
{
  DSConfiguration_sharedConfiguration = theConfiguration;

  return [self sharedInstance];
}

- (id)init
{
  if (DSConfiguration_sharedConfiguration) {
    self = [self initWithConfiguration:DSConfiguration_sharedConfiguration];
    DSConfiguration_sharedConfiguration = nil;
    return self;
  }
  else {
    return [self initWithConfiguration:[NSStringFromClass([self class]) loadPlistFromBundle]];
  }
}

+ (NSMutableDictionary *)sharedInstancesMap
{
    DEFINE_SHARED_INSTANCE_USING_BLOCK(^{
      return [[NSMutableDictionary alloc] init];
    });
}

+ (instancetype)sharedInstance
{
  @synchronized(self) {
    NSString *saveKey = NSStringFromClass([self class]);
    id sharedInstance = [[self sharedInstancesMap] valueForKey:saveKey];
    if (!sharedInstance) {
      sharedInstance = [[self alloc] init];
      [[self sharedInstancesMap] setValue:sharedInstance forKey:saveKey];
    }
    return sharedInstance;
  }
}

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context
{
  if (context == nil) {
    [self loadSettingsFromConfiguration:[self configuration]
                                 scheme:[self configurationScheme]];
  }
  else {
    [super observeValueForKeyPath:keyPath
                         ofObject:object
                           change:change
                          context:context];
  }
}

- (NSString *)description
{
  return [NSString stringWithFormat:@"%@", [self configuration]];
}
@end
