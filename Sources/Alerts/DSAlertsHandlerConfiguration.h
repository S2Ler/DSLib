
#import <Foundation/Foundation.h>


@interface DSAlertsHandlerConfiguration : NSObject
+ (id)sharedInstance;
+ (id)setupSharedInstanceWithConfigurationDictionary:(NSDictionary *)theConfiguration;

@property (nonatomic, strong, readonly) NSString *modelAlertsClassName;
@property (nonatomic, strong, readonly) NSString *messagesLocalizationTableName;
@end
