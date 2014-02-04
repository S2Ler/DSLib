
#import <Foundation/Foundation.h>
#import "DSMacros.h"

@class DSMessage;

@interface DSWebServiceResponse : NSObject

@property (nonatomic, strong, readonly) NSData *data;
- (instancetype)initWithData:(NSData *)theData DS_DESIGNATED_INIT;
+ (instancetype)responseWithData:(NSData *)theData;

@property (nonatomic, strong, readonly) NSString *path;
- (instancetype)initWithPath:(NSString *)path DS_DESIGNATED_INIT;
+ (instancetype)responseWithPath:(NSString *)path DS_DESIGNATED_INIT;

- (instancetype)initWithResponse:(DSWebServiceResponse *)response DS_DESIGNATED_INIT;
+ (instancetype)responseWithResponse:(DSWebServiceResponse *)response;

- (BOOL)parse;

- (NSDictionary *)responseDictionary;

@end

@interface DSWebServiceResponse (Abstract)
- (BOOL)isServerResponse;

- (BOOL)isSuccessfulResponse;

- (NSString *)errorCode;
- (DSMessage *)APIErrorMessage;

/** Needed for dynamic getter resolution.
 Usage:
 - create readonly property
 - overwrite keypathForGetter: method to return keypath in responseDictionary for this property
 - look into forwardInvocation: if some of the property types isn't supported and add a new handler
 */
- (NSString *)keypathForGetter:(NSString *)getter;
@end
