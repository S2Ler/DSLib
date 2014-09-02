
#import <Foundation/Foundation.h>

@interface DSWebServiceConfiguration : NSObject

/** 
 In you configuration dictionary/plist you can add postfix to each parameter
   which should be equal to configurationScheme. 
 If you omit configurationScheme or it cannot be found, 
   default scheme will be loaded. */
@property (strong) NSString *configurationScheme;

+ (instancetype)sharedInstance;
+ (instancetype)setupSharedInstanceWithConfigurationDictionary:(NSDictionary *)theConfiguration;

- (NSString *)serverURL;
- (NSString *)paramsDataOutputType;
- (NSString *)classPrefix;
- (BOOL)isFactoryShouldGenerateFakeRequests;
- (BOOL)HTTPSEnabled;
@end

@interface DSWebServiceConfiguration (UnitTests)
- (instancetype)initWithConfiguration:(NSDictionary *)theConfiguration;
@end
