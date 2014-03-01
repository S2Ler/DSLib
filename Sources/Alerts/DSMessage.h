
#import <Foundation/Foundation.h>
#import "DSAlertsSupportCode.h"

@class DSMessageContext;

#define NO_MESSAGE nil
#define FAILED_WITH_MESSAGE NO
#define SUCCEED_WITH_MESSAGE YES

@interface DSMessage: NSObject<NSCoding>

@property (nonatomic, strong) DSMessageContext *context;
@property (nonatomic, strong, readonly) DSMessageDomain *domain;
@property (nonatomic, strong, readonly) DSMessageCode *code;
@property (nonatomic, strong, readonly) NSArray *params;

- (NSString *)localizedTitle;
- (NSString *)localizedBody;

- (id)initWithDomain:(DSMessageDomain *)theDomain
                code:(DSMessageCode *)theCode
              params:(id)theParam, ... NS_REQUIRES_NIL_TERMINATION;

- (id)initWithDomain:(DSMessageDomain *)theDomain
                code:(DSMessageCode *)theCode;
+ (id)messageWithDomain:(DSMessageDomain *)theDomain
                   code:(DSMessageCode *)theCode;

- (id)initWithError:(NSError *)theError;
+ (id)messageWithError:(NSError *)theError;

- (BOOL)isEqualToMessage:(id)theObj;

+ (DSMessage *)unknownError;

@end
