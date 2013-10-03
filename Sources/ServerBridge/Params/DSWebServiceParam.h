
#import <Foundation/Foundation.h>

typedef enum
{
  DSWebServiceParamTypeRoot = 0,
  DSWebServiceParamTypeDictionary = 0,
  DSWebServiceParamTypeArray = 1,
  DSWebServiceParamTypeString = 2
} DSWebServiceParamType;

#define DSWebServiceParamEmbeddedIndexNotSet -1

@protocol DSWebServiceParam<NSObject, NSCoding>

@property (nonatomic, strong) NSDictionary *userInfo;

/** Used only in GET HTTP method in URLs like:
* http://www.server.net/functionName/paramValue1/paramValue2?paraName3=paramValue3.
* This parameter makes sense only for DSWebServiceParamTypeString param type.
* IMPORTANT: In implementation of string param type make default to:
* DSWebServiceParamEmbeddedIndexNotSet.
*/
@property (nonatomic, assign) NSInteger embeddedIndex;

/** Use these methods for GET based requests or simple POST.
* \return created string param
*/
- (id<DSWebServiceParam>)addStringValue:(NSString *)theValue
                           forParamName:(NSString *)theParam;

- (NSArray *)paramNames;

- (NSArray *)stringParamNames;

- (NSString *)stringValueForParamName:(NSString *)theParam;

- (void)enumerateStringValuesAndParamNamesWithBlock:(void (^)(NSString *param,
                                                              NSString *value))theBlock;
//-- These methods will work only for if you want to send params in the POST data 
- (void)enumerateParamsAndParamNamesWithBlock:(void (^)(id<DSWebServiceParam> param,
                                                        NSString *paramName))theBlock;

- (void)addParam:(id<DSWebServiceParam>)theParam
    forParamName:(NSString *)theName;

- (id<DSWebServiceParam>)paramForParamName:(NSString *)theParamName;

/** ArrayParam doesn't have paramNames, it stores params in ordered array */
- (DSWebServiceParamType)paramType;

@end
