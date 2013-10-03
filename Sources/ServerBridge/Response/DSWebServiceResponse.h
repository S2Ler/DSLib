
#import <Foundation/Foundation.h>

@class DSMessage;

@interface DSWebServiceResponse : NSObject

@property (nonatomic, retain, readonly) NSData *data;

- (id)initWithData:(NSData *)theData;
+ (id)responseWithData:(NSData *)theData;

- (id)initWithResponse:(DSWebServiceResponse *)response;
+ (id)responseWithResponse:(DSWebServiceResponse *)response;

- (BOOL)parse;

- (NSDictionary *)responseDictionary;

@end

@interface DSWebServiceResponse (Abstract)
- (BOOL)isServerResponse;

- (BOOL)isSuccessfulResponse;

- (NSString *)errorCode;
- (DSMessage *)APIErrorMessage;
@end
