
#import "DSWebServiceParams.h"
#import "DSEntityDefinition.h"
#import "DSWebServiceRequest.h"
#import "DSWebServiceParam.h"
#import "NSString+Extras.h"
#import "DSCFunctions.h"
#import "DSMacros.h"
#import "DSFakeWebServiceRequest.h"
#import "DSWebServiceConfiguration.h"
#import "DSWebServiceFunctions.h"
#import "MARTNSObject.h"
#import "RTProperty.h"

@implementation DSWebServiceParams
- (void)loadPropertiesFromClass:(Class)class intoDictionary:(NSMutableDictionary *)dictionary
{
  unsigned int count;
  objc_property_t *properties = class_copyPropertyList(class, &count);

  for (unsigned int idx = 0; idx < count; idx++) {
    const char *propertyName_cStr = property_getName(properties[idx]);
    NSString *propertyName = [NSString stringWithUTF8String:propertyName_cStr];
    [dictionary setValue:[self valueForKey:propertyName] forKey:propertyName];
  }

  free(properties);
}

- (NSDictionary *)allParams
{
  NSArray *allParamNames = [self allParamNames];
  NSMutableDictionary *params = [NSMutableDictionary dictionary];
  
  for (NSString *paramName in allParamNames) {
    id value = [self valueForKeyPath:paramName];
    if (value) {
      params[paramName] = value;
    }
  }
  
  return params;
}

- (DSEntityDefinition *)entityDefinitionWithClass:(Class)theDefinitionClass
{
  DSEntityDefinition *definition = [[theDefinitionClass alloc] initWithDictionary:[self allParams]];
  return definition;
}

- (void)loadParamsValuesFromDefinition:(DSEntityDefinition *)theDefinition
{
  NSArray *allParamsNames = [self allParamNames];
  for (NSString *key in allParamsNames) {
    id value = [theDefinition valueForKey:key];

    if ([value isKindOfClass:[NSArray class]]) {
      value = [theDefinition rawDefinitionsArrayValueWithName:key];
    }

    [self setValue:value forKey:key];
  }
}

+ (instancetype)params
{
  return [[[self class] alloc] init];
}

+ (instancetype)paramsForEntityName:(NSString *)theEntityName
                      operationType:(DSWebServiceOperationType)theOperationType
{
  NSAssert([theEntityName hasPrefix:[self classPrefix]], nil);

  NSMutableString *paramsClassName = [NSMutableString stringWithFormat:@"%@WebServiceParams", [self classPrefix]];
  NSString *entityNameWithoutPrefix = [theEntityName stringByRemovingPrefix:[self classPrefix]];
  [paramsClassName appendString:entityNameWithoutPrefix];
  NSString *operationName = NSStringFromDSWebServiceOperationType(theOperationType);
  [paramsClassName appendString:operationName];

  Class paramsClass = NSClassFromString(paramsClassName);
  DSWebServiceParams *params = [paramsClass params];
  return params;
}

- (NSString *)functionName
{
  NSString *function = [[DSWebServiceFunctions sharedInstance] functionForParams:self];
  NSAssert([function hasValue], @"DSWebServiceFunctions doesn't contain definition for %@ params",
           NSStringFromClass([self class]));
  return function;
}

- (DSWebServiceURLHTTPMethod)HTTPMethod
{
  ASSERT_ABSTRACT_METHOD;
  return DSWebServiceURLHTTPMethodGET;
}

- (NSData *)POSTData
{
  return nil;
}

- (NSString *)POSTDataPath
{
  return nil;
}

- (NSString *)POSTDataFileName
{
  return nil;
}

- (NSString *)customServerURL
{
  return nil;
}

- (DSRelativePath *)outputPath
{
  return nil;
}

- (BOOL)embedParamsInURLForPOSTRequest
{
  return NO;
}

- (NSArray *)paramsEmbeddedInURL
{
  return [NSArray array];
}

- (NSArray *)allParamNames
{
  Class class = [self class];
  
  NSMutableArray *properties = [NSMutableArray array];
  
  while (class != [DSWebServiceParams class]) {
    NSArray *classProperties = [class rt_properties];
    [properties addObjectsFromArray:[classProperties valueForKeyPath:@"name"]];
    
    class = [class superclass];
  };
  
  return properties;
}

+ (BOOL)isCorrespondsToRequest:(id<DSWebServiceRequest>)theRequest
{
  if ([theRequest isKindOfClass:[DSFakeWebServiceRequest class]]) {
    DSFakeWebServiceRequest *fakeRequest = (id)theRequest;
    return [fakeRequest paramsClass] == [self class];
  }

  DSWebServiceParams *params = [[[self class] alloc] init];

  BOOL isFunctionAndMethodTheSame
  = [theRequest isRequestWithFunctionName:[params functionName]
                               HTTPMethod:[params HTTPMethod]];
  __block BOOL isParamNamesAreTheSame = YES;

  if (isFunctionAndMethodTheSame) {
    NSArray *allParamNames = [params allParamNames];
    NSArray *embeddedParamNames = [params paramsEmbeddedInURL];
    if (allParamNames) {
      [[theRequest params]
       enumerateParamsAndParamNamesWithBlock:^(id<DSWebServiceParam> param,
                                               NSString *paramName)
       {
         if (isParamNamesAreTheSame == NO) {
           return;
         }
         
         if (
             !([param embeddedIndex] == DSWebServiceParamEmbeddedIndexNotSet &&
               [allParamNames containsObject:paramName] &&
               ![embeddedParamNames containsObject:paramName]) &&
             
             !([param embeddedIndex] != DSWebServiceParamEmbeddedIndexNotSet &&
               [embeddedParamNames containsObject:paramName])){
               isParamNamesAreTheSame = NO;
             }
       }];
    }
    else if ([allParamNames count] != [[[theRequest params] paramNames] count]) {
      isParamNamesAreTheSame = NO;
    }
  }
  return isFunctionAndMethodTheSame && isParamNamesAreTheSame;
}

- (NSString *)description
{
  return [NSString stringWithFormat:@"%@", [self allParams]];
}

//===========================================================
//  Keyed Archiving
//
//===========================================================
- (void)encodeWithCoder:(NSCoder *)encoder
{
  NSArray *allParamNames = [self allParamNames];
  NSMutableDictionary *allParams = [NSMutableDictionary dictionary];
  for (NSString *paramName in allParamNames) {
    [allParams setValue:[self valueForKey:paramName] forKey:paramName];
  }
  [encoder encodeObject:allParams forKey:@"params"];
}

- (id)initWithCoder:(NSCoder *)decoder
{
  self = [super init];
  if (self) {
    NSDictionary *allParams = [decoder decodeObjectForKey:@"params"];
    for (NSString *paramName in [allParams allKeys]) {
      [self setValue:[allParams valueForKey:paramName] forKey:paramName];
    }
  }
  return self;
}

+ (NSString *)classPrefix
{
  return [[DSWebServiceConfiguration sharedInstance] classPrefix];
}
@end
