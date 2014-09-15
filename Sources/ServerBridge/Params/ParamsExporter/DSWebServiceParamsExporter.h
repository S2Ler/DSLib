
#import <Foundation/Foundation.h>
#import "DSWebServiceCompositeParams.h"
@protocol DSWebServiceParamsBuilder;

typedef void (^params_exported_handler_t)(NSData *paramsData);

@interface DSWebServiceParamsExporter : NSObject
- (id)initWithParams:(DSWebServiceCompositeParams *)theParams
             builder:(id<DSWebServiceParamsBuilder>)theBuilder NS_DESIGNATED_INITIALIZER;
/** Builder will be chosen based on
 DSWebServiceConfiguration paramsDataOutputType property */
- (id)initWithParams:(DSWebServiceCompositeParams *)theParams;

/** Exports params asynchronously. The result are delivered in delegate calls */
- (void)exportWithCompletionHandler:(params_exported_handler_t)theHandler;
/** Synchronous call */
- (NSData *)exportParamsData;
@end
