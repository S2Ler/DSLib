@import Foundation;


@interface XibLoader : NSObject {
    
}

+ (NSArray *)xibNamed:(NSString *)theXibName;
+ (NSArray *)xibNamed:(NSString *)theXibName inBundle:(NSBundle *)bundle;
+ (id)firstViewInXibNamed:(NSString *)theXibName;
+ (id)firstViewInXibNamed:(NSString *)theXibName inBundle:(NSBundle *)bundle;
@end
