
#import "DSAlertsHandlerConfiguration.h"
#import "DSMacros.h"
#import "NSString+Extras.h"
#import "NSString+Encoding.h"

static NSDictionary *DSAlertsHandlerConfiguration_sharedConfiguration = nil;

@interface DSAlertsHandlerConfiguration ()
@property (strong) NSDictionary *configuration;
@property (nonatomic, strong) NSString *modelAlertsClassName;

- (NSString *)keyForConfigurationKey:(NSString *)theConfigurationKey;


@end

@implementation DSAlertsHandlerConfiguration

- (NSString *)keyForConfigurationKey:(NSString *)theConfigurationKey
{
  return theConfigurationKey;
}

- (void)loadSettingsFromConfiguration:(NSDictionary *)theConfiguration
{
  [theConfiguration
   enumerateKeysAndObjectsUsingBlock:^(NSString *configKey, id obj, BOOL *stop) {
     NSString *key = [self keyForConfigurationKey:configKey];
     if (key != nil) {
       [self setValue:obj forKey:key];
     }
   }];
}

- (id)initWithConfiguration:(NSDictionary *)theConfiguration
{
  self = [super init];
  if (self) {
    _configuration = theConfiguration;
    
    [self loadSettingsFromConfiguration:_configuration];
  }
  return self;
  
}

+ (id)setupSharedInstanceWithConfigurationDictionary:(NSDictionary *)theConfiguration
{
  DSAlertsHandlerConfiguration_sharedConfiguration = theConfiguration;
  
  return [self sharedInstance];
}

- (id)init {
  if (DSAlertsHandlerConfiguration_sharedConfiguration) {
    return [self initWithConfiguration:DSAlertsHandlerConfiguration_sharedConfiguration];
  }
  else {
    return [self initWithConfiguration:
            [NSStringFromClass([self class]) loadPlistFromBundle]];
  }
}

+ (id)sharedInstance
{
  DEFINE_SHARED_INSTANCE_USING_BLOCK(^{
    return [[self alloc] init];
  });
}

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context
{
  if (context == nil) {
    [self loadSettingsFromConfiguration:[self configuration]];
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
