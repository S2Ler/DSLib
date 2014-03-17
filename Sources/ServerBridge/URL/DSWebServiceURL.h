
#import <Foundation/Foundation.h>
#import "DSWebServiceURLHTTPMethod.h"

@protocol DSWebServiceParam;

/** if you use DSWebServiceURLHTTPMethodPOST params will be embedded in POST */
@interface DSWebServiceURL : NSObject<NSCoding>
@property (nonatomic, strong, readonly) NSString *urlString;
@property (nonatomic, assign) DSWebServiceURLHTTPMethod HTTPMethod;
@property (nonatomic, strong, readonly) NSString *functionName;

+ (id)urlWithHTTPMethod:(DSWebServiceURLHTTPMethod)theHTTPMethod
           functionName:(NSString *)theFunctionName
             forceHTTPS:(BOOL)forceHTTPS;
+ (id)urlWithHTTPMethod:(DSWebServiceURLHTTPMethod)theHTTPMethod
           functionName:(NSString *)theFunctionName
             forceHTTPS:(BOOL)forceHTTPS
        customServerURL:(NSString *)serverURL;

/**
 * Designated init
 */
- (id)initWithHTTPMethod:(DSWebServiceURLHTTPMethod)theHTTPMethod
            functionName:(NSString *)theFunctionName
              forceHTTPS:(BOOL)forceHTTPS
         customServerURL:(NSString *)serverURL;

- (id)initWithHTTPMethod:(DSWebServiceURLHTTPMethod)theHTTPMethod
            functionName:(NSString *)theFunctionName
              forceHTTPS:(BOOL)forceHTTPS;

- (void)applyParams:(id<DSWebServiceParam>)theParams;

/** \return not nil data only for HTTPMethod == DSWebServiceURLHTTPMethodPOST.
 Used to send params with POST method. */
@property (nonatomic, strong, readonly) NSData *paramsDataForPOST;

@end
