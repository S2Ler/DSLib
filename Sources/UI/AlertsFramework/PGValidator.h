
#import <Foundation/Foundation.h>

@class PGAlertMessage;

@interface PGValidator : NSObject {
    
}

+ (PGAlertMessage *)validateEmail:(NSString *)theEmail;

@end
