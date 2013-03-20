
#pragma mark =================imports=================
#import "FontsDB.h"
#import "UIFont+FromString.h"

#pragma mark =================static=================
static FontsDB *sharedInstance = nil;
GUIElements guiElements = {
	@"homeTopNewsTitle",
};

@implementation FontsDB
#pragma mark ----------------Singleton----------------
+ (FontsDB *)sharedInstance {
	@synchronized(self) {
		if (sharedInstance == nil) {
			sharedInstance = [[FontsDB alloc] init];
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

- (void)initFontManagerFonts {
	NSDictionary *fontsNamesDict = 
	[NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"UIFontsNames"
																			   ofType:@"plist"]];

	for (NSString *fontKey in [fontsNamesDict keyEnumerator]) {
		[fontManager_ addFontWithKey:fontKey
								font:[UIFont fontFromString:[fontsNamesDict objectForKey:fontKey]]];
	}
}

- (id) init
{
	self = [super init];
	if (self != nil) {				
		fontManager_ = [DSFontManager sharedInstance];
		[self initFontManagerFonts];
	}
	return self;
}

- (id)copyWithZone:(NSZone *)zone {
	return self;
}

#pragma mark =================methods=================
- (UIFont *)fontForGUIElement:(NSString *)aGUIElement {
	return [fontManager_ fontWithKey:aGUIElement];
}
@end
