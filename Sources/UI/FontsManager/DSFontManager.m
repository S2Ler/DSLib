
#pragma mark =================imports=================
#import "DSFontManager.h"

#pragma mark =================private=================
@interface DSFontManager()

@end

#pragma mark =================static=================
static DSFontManager *sharedInstance = nil;

@implementation DSFontManager
#pragma mark ----------------Singleton----------------
+ (DSFontManager *)sharedInstance {
	@synchronized(self) {
		if (sharedInstance == nil) {
			sharedInstance = [[ITFontManager alloc] init];
		}
	}
	return sharedInstance;
}

+ (id)allocWithZone:(NSZone *)zone {
	@synchronized(self) {
		if (sharedInstance == nil) {
			sharedInstance = [super allocWithZone:zone];
			return sharedInstance;
		}
	}
	
	return nil;
}

- (id) init
{
	self = [super init];
	if (self != nil) {				
		fontsDictionary_ = [[NSMutableDictionary alloc] init];
	}
	return self;
}

- (id)copyWithZone:(NSZone *)zone {
	return self;
}

- (id)retain {
	return self;
}

- (void)release {
	//do nothing
}

- (id)autorelease {
	return self;
}

#pragma mark =================methods=================
- (void)addFontWithKey:(NSString *)aFontKey
				  font:(UIFont *)aFont {
	NSAssert(aFontKey != nil && aFont != nil, @"Wrong use of mehtod.");
	[fontsDictionary_ setObject:aFont
						 forKey:aFontKey];
}

- (UIFont *)fontWithKey:(NSString *)aKey {
	return [fontsDictionary_ objectForKey:aKey];
}


@end
