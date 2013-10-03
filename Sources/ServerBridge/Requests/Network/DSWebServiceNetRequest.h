
#import <Foundation/Foundation.h>
#import "DSWebServiceRequest.h"
#import "QRunLoopOperation.h"

@protocol DSWebServiceParam;
@class DSWebServiceURL;
@class DSWebServiceResponse;
@protocol DSWebServiceRequestDelegate;

#define MAX_RAW_DATA_BYTES_LOG NSUIntegerMax

@interface DSWebServiceNetRequest : QRunLoopOperation <DSWebServiceRequest>

@property (nonatomic, retain, readonly) DSWebServiceURL *url;

#pragma mark - init
- (id)initWithServer:(DSWebServiceURL *)theWebServiceURL
              params:(id<DSWebServiceParam>)theParams
            userInfo:(NSMutableDictionary *)theUserInfo;

- (id)initWithServer:(DSWebServiceURL *)theWebServiceURL
              params:(id<DSWebServiceParam>)theParams;

+ (id)requestWithServer:(DSWebServiceURL *)theWebServiceURL
                 params:(id<DSWebServiceParam>)theParams
               userInfo:(NSMutableDictionary *)theUserInfo;

+ (id)requestWithServer:(DSWebServiceURL *)theWebServiceURL
                 params:(id<DSWebServiceParam>)theParams;

@end
