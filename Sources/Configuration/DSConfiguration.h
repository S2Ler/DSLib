
@import Foundation;

/**
* Handy class for encapsulating configuration keys.
 * If setupSharedInstanceWithConfigurationDictionary hasn't been called DSConfiguration.plist dictionary will be used.
 * Subclass Notes:
  * Implement properties for all configuration keys in configuration dictionary.
  * If you don't implement properties, the values from configuration are always accessible with KVC methods, with support for keypaths.
  * Use setupSharedInstanceWithConfigurationDictionary: to provide your configuration dictionary which matches properties, you've implemented in you subclass.
*/
@interface DSConfiguration: NSObject
/**
* In you configuration dictionary/plist you can add postfix to each parameter which should be equal to configurationScheme.
* If you omit configurationScheme or it cannot be found, default scheme will be loaded (default scheme is a key without any '_SCHEME' at the end.
*/
@property (strong) NSString *configurationScheme;

/** [CLASS_NAME].plist is used if setupSharedInstanceWithConfigurationDictionary: wasn't called before */
+ (instancetype)sharedInstance;

/** Use your own custom configuration dictionary to configure shared instance */
+ (instancetype)setupSharedInstanceWithConfigurationDictionary:(NSDictionary *)theConfiguration;

@end
