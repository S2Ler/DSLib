
#import <Foundation/Foundation.h>

@class DSMessage;

typedef NSString DSMessageCode;
typedef NSString DSMessageDomain;

BOOL DSMessageDomainsEqual(DSMessageDomain *domain1, DSMessageDomain *domain2);

BOOL DSMessageCodesEqual(DSMessageCode *code1, DSMessageCode *code2);
