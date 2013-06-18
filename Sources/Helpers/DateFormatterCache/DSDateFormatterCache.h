
#import <Foundation/Foundation.h>

/** All cached NSDateFormatters will receive new locale on change */
@interface DSDateFormatterCache : NSObject {
  NSMutableDictionary *_cache;
}

+ (void)cacheDateFormatter:(NSDateFormatter *)theDateFormatter
                    forKey:(NSString *)theKey;

+ (void)cacheDateFormatter:(NSDateFormatter *)theDateFormatter
                  forClass:(Class)theClass;

+ (NSDateFormatter *)dateFormatterForKey:(NSString *)theKey;
+ (NSDateFormatter *)dateFormatterForClass:(Class)theClass;


@end
