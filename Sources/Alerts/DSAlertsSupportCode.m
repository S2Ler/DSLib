
#import "DSAlertsSupportCode.h"

BOOL DSMessageDomainsEqual(DSMessageDomain *domain1, DSMessageDomain *domain2)
{
  return [domain1 isEqual:domain2];
}

BOOL DSMessageCodesEqual(DSMessageCode *code1, DSMessageCode *code2) {
  return [code1 isEqual:code2];
}
