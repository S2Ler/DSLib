
#import "NSError+DSWebService.h"

NSString *kDSMessageDomainWebService = @"DSMessageDomainWebService";
NSString *kDSMessageDomainWebServiceErrorUnknown = @"err_server";

@implementation NSError (DSAdditions)
+ (NSError *)errorWithDescription:(NSString *)theDescription
                           domain:(NSString *)theDomain
                             code:(NSInteger)theCode
{    
    NSString *errorString = NSLocalizedString(theDescription, nil);
    NSDictionary *userInfoDict =
    [NSDictionary dictionaryWithObject:errorString
                                forKey:NSLocalizedDescriptionKey];
    NSError *error = [[NSError alloc] initWithDomain:theDomain
                                                code:theCode
                                            userInfo:userInfoDict];
    return error;    
}
@end
