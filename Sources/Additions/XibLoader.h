#import <Foundation/Foundation.h>


@interface XibLoader : NSObject {
    
}

+ (NSArray *)xibNamed:(NSString *)theXibName;
+ (id)firstViewInXibNamed:(NSString *)theXibName;
@end
