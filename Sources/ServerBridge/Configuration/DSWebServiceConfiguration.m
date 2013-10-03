
#pragma mark - include
#import "DSWebServiceConfiguration.h"
#import "DSMacros.h"
#import "NSString+Extras.h"
#import "NSString+Encoding.h"

static NSDictionary *DSWebServiceConfiguration_sharedConfiguration = nil;

@interface DSWebServiceConfiguration()
@property (strong) NSString *serverURL;
@property (strong) NSString *paramsDataOutputType;
@property (strong) NSDictionary *configuration;
@property (strong) NSString *classPrefix;
@property (strong) NSNumber *generateFakeRequests;

- (NSString *)keyForConfigurationKey:(NSString *)theConfigurationKey
                              scheme:(NSString *)theScheme;

@end

@implementation DSWebServiceConfiguration

- (void)dealloc
{
  [self removeObserver:self forKeyPath:@"configurationScheme"];  
}

- (NSString *)keyForConfigurationKey:(NSString *)theConfigurationKey
                              scheme:(NSString *)theScheme
{
  NSArray *components = [theConfigurationKey componentsSeparatedByString:@"_"];
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
    schemePostfix = [NSString stringWithFormat:@"_%@", theScheme];    
  }
  else {
    schemePostfix = nil;
  }

  [theConfiguration
   enumerateKeysAndObjectsUsingBlock:^(NSString *configKey, id obj, BOOL *stop) {
     if ([configKey containsString:schemePostfix] == YES || schemePostfix == nil) {
       NSString *key = [self keyForConfigurationKey:configKey scheme:schemePostfix];
       if (key != nil) {
         [self setValue:obj forKey:key];
       }
     }
   }];
}

- (id)initWithConfiguration:(NSDictionary *)theConfiguration
{
  self = [super init];
  if (self) {
    _configuration = theConfiguration;
    
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
  DSWebServiceConfiguration_sharedConfiguration = theConfiguration;
  
  return [self sharedInstance];
}

- (BOOL)isFactoryShouldGenerateFakeRequests
{
  return [[self generateFakeRequests] boolValue];
}


- (id)init {
  if (DSWebServiceConfiguration_sharedConfiguration) {
    return [self initWithConfiguration:DSWebServiceConfiguration_sharedConfiguration];    
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
