
@import Foundation;

typedef enum __DSWebServiceOperationType
{
  DSWebServiceOperationTypeCreate,
  DSWebServiceOperationTypeList,
  DSWebServiceOperationTypeFetch,
  DSWebServiceOperationTypeModify,
  DSWebServiceOperationTypeDelete
} DSWebServiceOperationType;

NSString *NSStringFromDSWebServiceOperationType(DSWebServiceOperationType theType);
