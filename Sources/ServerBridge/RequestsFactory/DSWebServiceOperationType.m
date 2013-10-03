
#import "DSWebServiceOperationType.h"

NSString *NSStringFromDSWebServiceOperationType(DSWebServiceOperationType theType)
{
  switch (theType) {
    case DSWebServiceOperationTypeCreate:
      return @"Create";
    case DSWebServiceOperationTypeList:
      return @"List";
    case DSWebServiceOperationTypeFetch:
      return @"Fetch";
    case DSWebServiceOperationTypeModify:
      return @"Modify";
    case DSWebServiceOperationTypeDelete:
      return @"Delete";
    default: {
      assert(FALSE);
      return nil;
    }
  }
}

