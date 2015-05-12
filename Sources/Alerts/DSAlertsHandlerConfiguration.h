
@import Foundation;


@interface DSAlertsHandlerConfiguration : NSObject
+ (id)sharedInstance;
+ (id)setupSharedInstanceWithConfigurationDictionary:(NSDictionary *)theConfiguration;

@property (nonatomic, strong, readonly) NSString *modelAlertsClassName;
@property (nonatomic, strong, readonly) NSString *messagesLocalizationTableName;
@property (nonatomic, assign, readonly) NSNumber *showGeneralMessageForUnknownCodes;
@property (nonatomic, assign, readonly) NSNumber *showOfflineErrorsMoveThanOnce;
@end
