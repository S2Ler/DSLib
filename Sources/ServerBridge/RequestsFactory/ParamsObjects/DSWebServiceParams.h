
@import Foundation;
#import "DSWebServiceURLHTTPMethod.h"
#import "DSWebServiceOperationType.h"

@class DSEntityDefinition;
@protocol DSWebServiceRequest;
@class DSWebServiceResponse;
@class DSRelativePath;

/** 
 Create concrete subclass which should contain defined properties for all params. 
 Property names should be equal to WebService requests param names.
 IMPORTANT: @synthesize paramName; not @synthesize paramName = whatEver;
 The rest will be handled by this class.
 */
@interface DSWebServiceParams: NSObject<NSCoding>
/** paramName->value */
- (NSDictionary *)allParams;

/** As params and entity definition use the same data model - NSDictionary with
* the same params, we support params<->definition conversion.
*/
- (DSEntityDefinition *)entityDefinitionWithClass:(Class)theDefinitionClass;
- (void)loadParamsValuesFromDefinition:(DSEntityDefinition *)theDefinition;

+ (instancetype)params;
//TODO: adapt docs
/** \param theEntityName like: OCalendar, OToDo, etc */
+ (instancetype)paramsForEntityName:(NSString *)theEntityName
                      operationType:(DSWebServiceOperationType)theOperationType;

+ (BOOL)isCorrespondsToRequest:(id<DSWebServiceRequest>)theRequest;

@end

@interface DSWebServiceParams (Abstract)
- (NSString *)functionName;
- (DSWebServiceURLHTTPMethod)HTTPMethod;
- (NSData *)POSTData;
- (NSString *)POSTDataPath;
- (NSString *)POSTDataFileName;
- (NSString *)customServerURL;
/** Default NO */
- (BOOL)embedParamsInURLForPOSTRequest;

/** If not nil, the response data will be written to this path */
- (DSRelativePath *)outputPath;

/** The ordered list of param names which should be embedded in main URL scheme:
* The example:
* http://www.server.net/functionName/paramValue1/paramValue2?paraName3=paramValue3
* In this example paramValue1 and paramValue2 are values of params with names paramName1
  * and paramName2. For this example you should return [@"paramName1", @"paramName2"]
*/
- (NSArray *)paramsEmbeddedInURL;
/** Subclass and return all meaningful param names */
- (NSArray *)allParamNames;
@end

#define VALIDATE_FOR_EMPTY_PARAM_WITH_NAME(name) - (BOOL)validate##name:(NSString *)theValidatedValue error:(NSError *__autoreleasing *)outError {return [self validateForEmptyStringWithValue:theValidatedValue        validationSelector:_cmd error:outError]; }
