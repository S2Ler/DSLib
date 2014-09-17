
#import <Foundation/Foundation.h>
#import "DSMacros.h"
#import "DSDynamicPropertyObject.h"

@class DSMessage;
@class DSRelativePath;

@interface DSWebServiceResponse : DSDynamicPropertyObject

@property (nonatomic, strong, readonly) NSData *data;
- (instancetype)initWithData:(NSData *)theData NS_DESIGNATED_INITIALIZER;
+ (instancetype)responseWithData:(NSData *)theData;

@property (nonatomic, strong, readonly) DSRelativePath *path;
- (instancetype)initWithPath:(DSRelativePath *)path NS_DESIGNATED_INITIALIZER;
+ (instancetype)responseWithPath:(DSRelativePath *)path;

- (instancetype)initWithResponse:(DSWebServiceResponse *)response NS_DESIGNATED_INITIALIZER;
+ (instancetype)responseWithResponse:(DSWebServiceResponse *)response;

- (BOOL)parse;

- (NSDictionary *)responseDictionary;

@end

@interface DSWebServiceResponse (Abstract)
- (BOOL)isServerResponse;

- (BOOL)isSuccessfulResponse;

- (NSString *)errorCode;
- (DSMessage *)APIErrorMessage;
@end
