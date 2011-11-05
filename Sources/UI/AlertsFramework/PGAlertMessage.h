
#import <Foundation/Foundation.h>

@interface PGAlertMessage : NSObject
@property (nonatomic, retain) NSString *title;
@property (nonatomic, retain) NSString *message;

+ (PGAlertMessage *)messageWithTitle:(NSString *)theTitle
                             message:(NSString *)theMessage;

- (id)initWithTitle:(NSString *)theTitle
            message:(NSString *)theMessage;
@end
