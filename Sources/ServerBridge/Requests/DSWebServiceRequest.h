#import "DSWebServiceRequestDelegate.h"
#import "DSWebServiceURLHTTPMethod.h"

@protocol DSWebServiceParam;
@class DSWebServiceURL;
@class DSWebServiceResponse;

@protocol DSWebServiceRequest<NSObject>

@property (copy, readonly) NSError *error;

@property (nonatomic, weak) id<DSWebServiceRequestDelegate> delegate;

@property (nonatomic, strong) NSMutableDictionary *userInfo;

@property (nonatomic, strong) id<DSWebServiceParam> params;

@property (nonatomic, assign) BOOL sendRawPOSTData;

/** if not nil this request will use HTTP POST method to send the data */
@property (nonatomic, strong) NSData *POSTData;

/** If not nil this request will use HTTP POST method to send data from
 this path. If POSTData property also has been set this property takes 
 priority */
@property (nonatomic, strong) NSString *POSTDataPath;

/** If not nil and POSTDataFileName == nil, POSTData will be sent
 as parameter data, otherwise as file. */
@property (nonatomic, strong) NSString *POSTDataKey;

/** The file name for the POST form-data request */
@property (nonatomic, strong) NSString *POSTDataFileName;

@property (nonatomic, assign) NSTimeInterval timeoutInterval;

- (DSWebServiceURL *)url;

- (DSWebServiceResponse *)response;

- (void)send;
- (void)cancel;
- (BOOL)isCancelled;

- (BOOL)isRequestWithFunctionName:(NSString *)theFunctionName 
                       HTTPMethod:(DSWebServiceURLHTTPMethod)theHTTPMethod;
- (NSString *)functionName;

- (void)addDependency:(NSOperation *)op;

- (void)removeDependency:(NSOperation *)op;

- (NSArray *)dependencies;

- (void)setCompletionBlock:(void (^)(void))block;

@end
