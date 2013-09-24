
#import <Foundation/Foundation.h>

/**
* Handy class for encapsulating configuration keys.
 * If setupSharedInstanceWithConfigurationDictionary hasn't been called DSConfiguration.plist dictionary will be used.
 * Subclass Notes:
  * Implement getters and setters for all configuration keys in configuration dictionary.
  * Use setupSharedInstanceWithConfigurationDictionary: to provide your configuration dictionary which matches properties,
  * you've implemented in you subclass.
*/
@interface DSConfiguration: NSObject
/**
* In you configuration dictionary/plist you can add postfix to each parameter which should be equal to configurationScheme.
* If you omit configurationScheme or it cannot be found, default scheme will be loaded (default scheme is a key without any '_SCHEME' at the end.
*/
@property (strong) NSString *configurationScheme;

/** DSConfiguration.plist is used if setupSharedInstanceWithConfigurationDictionary: wasn't called before */
+ (id)sharedInstance;

/** Use your own custom configuration dictionary to configure shared instance */
+ (id)setupSharedInstanceWithConfigurationDictionary:(NSDictionary *)theConfiguration;

@end
