#import <Foundation/Foundation.h>

@protocol DSWebServiceRequest;
@class DSWebServiceResponse;

@protocol DSWebServiceRequestDelegate <NSObject>
@optional
- (void)                 webServiceRequest:(id <DSWebServiceRequest>)theRequest
didReceiveResponseWithExpectedDownloadSize:(long long)theExpectedSize;

- (void)webServiceRequest:(id <DSWebServiceRequest>)theRequest
      didReceiveTotalSize:(long long)theReceivedSize
      expectedReceiveSize:(long long)theExpectedSize;

- (void)webServiceRequest:(id <DSWebServiceRequest>)theRequest
         didFailWithError:(NSError *)theError;

- (void)webServiceRequest:(id <DSWebServiceRequest>)theRequest
   didEndLoadWithResponse:(DSWebServiceResponse *)theResponse;
@end
