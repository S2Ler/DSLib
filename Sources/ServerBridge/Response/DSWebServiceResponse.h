
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

/** Needed for dynamic getter resolution.
 Usage:
 - create readonly property
 - overwrite keypathForGetter: method to return keypath in responseDictionary for this property
 - look into forwardInvocation: if some of the property types isn't supported and add a new handler
 */
- (NSString *)keypathForGetter:(NSString *)getter;
@end
