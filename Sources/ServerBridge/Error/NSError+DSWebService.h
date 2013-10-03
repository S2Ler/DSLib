
#import <Foundation/Foundation.h>

extern NSString *kDSMessageDomainWebService;
extern NSString *kDSMessageDomainWebServiceErrorUnknown;

@interface NSError (DSWebService)
+ (NSError *)errorWithDescription:(NSString *)theDescription
                           domain:(NSString *)theDomain
                             code:(NSInteger)theCode;
@end
