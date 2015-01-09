
@import Foundation;


@interface DSFontManager : NSObject {
	NSMutableDictionary *fontsDictionary_;
}

+ (DSFontManager *)sharedInstance;

- (void)addFontWithKey:(NSString *)aFontKey
				  font:(UIFont *)aFont;

- (UIFont *)fontWithKey:(NSString *)aKey;
@end
