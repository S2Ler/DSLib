
#import <Foundation/Foundation.h>

typedef enum __DSWebServiceOperationType
{
  DSWebServiceOperationTypeCreate,
  DSWebServiceOperationTypeList,
  DSWebServiceOperationTypeFetch,
  DSWebServiceOperationTypeModify,
  DSWebServiceOperationTypeDelete
} DSWebServiceOperationType;

NSString *NSStringFromDSWebServiceOperationType(DSWebServiceOperationType theType);
