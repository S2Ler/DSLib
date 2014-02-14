#import <Foundation/Foundation.h>
#import "DSConstants.h"

@protocol DSWebServiceRequest;
@class DSWebServiceResponse;

@protocol DSWebServiceRequestDelegate <NSObject>
@optional
- (void)                 webServiceRequest:(id <DSWebServiceRequest>)theRequest
didReceiveResponseWithExpectedDownloadSize:(long long)theExpectedSize;

- (void)webServiceRequest:(id <DSWebServiceRequest>)theRequest
           didReceiveSize:(DSFileSize)theReceivedSize
      expectedReceiveSize:(DSFileSize)theExpectedSize;

- (void)webServiceRequest:(id <DSWebServiceRequest>)theRequest
         didFailWithError:(NSError *)theError;

- (void)webServiceRequest:(id <DSWebServiceRequest>)theRequest
   didEndLoadWithResponse:(DSWebServiceResponse *)theResponse;
@end
