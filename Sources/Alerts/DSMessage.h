#import <Foundation/Foundation.h>
#import "DSAlertsSupportCode.h"

@class DSMessageContext;

@interface DSMessage: NSObject <NSCoding>

@property (nonatomic, strong) DSMessageContext *context;
@property (nonatomic, strong, readonly) DSMessageDomain *domain;
@property (nonatomic, strong, readonly) DSMessageCode *code;
@property (nonatomic, strong, readonly) NSArray *params;

@property (nonatomic, strong) NSArray *titleParams;

- (NSString *)localizedTitle;

- (NSString *)localizedBody;

/**
* @param theParam params for body text. to set params for title text, user titleParams property.
*/
- (instancetype)initWithDomain:(DSMessageDomain *)theDomain
                          code:(DSMessageCode *)theCode
                        params:(id)theParam, ... NS_REQUIRES_NIL_TERMINATION;


- (instancetype)initWithDomain:(DSMessageDomain *)theDomain
                          code:(DSMessageCode *)theCode;

+ (instancetype)messageWithDomain:(DSMessageDomain *)theDomain
                             code:(DSMessageCode *)theCode;

- (instancetype)initWithTitle:(NSString *)title
                      message:(NSString *)message;

+ (instancetype)messageWithTitle:(NSString *)title
                         message:(NSString *)message;

- (instancetype)initWithError:(NSError *)theError;

+ (instancetype)messageWithError:(NSError *)theError;

- (BOOL)isEqualToMessage:(id)theObj;

+ (instancetype)unknownError;

- (BOOL)isGeneralErrorMessage;

- (BOOL)isEqualToError:(NSError *)error;
- (BOOL)isEqualToDomain:(DSMessageDomain *)domain codeInteger:(NSInteger)code;
- (BOOL)isEqualToDomain:(DSMessageDomain *)domain code:(DSMessageCode *)code;

@end
