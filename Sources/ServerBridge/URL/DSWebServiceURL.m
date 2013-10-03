#pragma mark - include
#import "DSWebServiceURL.h"
#import "DSWebServiceCompositeParams.h"
#import "DSWebServiceConfiguration.h"
#import "DSWebServiceParamsExporter.h"
#import "NSString+Encoding.h"
#import "NSString+Extras.h"

#pragma mark - props
@interface DSWebServiceURL ()

@property (nonatomic, strong) NSString *urlString;
@property (nonatomic, strong) NSData *paramsDataForPOST;
@property (nonatomic, strong) NSString *functionName;

@end

#pragma mark - private
@interface DSWebServiceURL (Private)
- (NSString *)appendFunctionName:(NSString *)theFunction
                    toServerName:(NSString *)theServerName;
@end

@implementation DSWebServiceURL
@synthesize paramsDataForPOST = _paramsDataForPOST;
@synthesize urlString = _urlString;
@synthesize functionName = _functionName;
@synthesize HTTPMethod = _HTTPMethod;



#pragma mark - init
- (id)init
{
  return [self initWithHTTPMethod:DSWebServiceURLHTTPMethodGET
                     functionName:nil];
}

- (NSString *)urlWithoutParams
{
  return [self appendFunctionName:[self functionName]
               toServerName:[[DSWebServiceConfiguration sharedInstance] serverURL]];
}

- (id)initWithHTTPMethod:(DSWebServiceURLHTTPMethod)theHTTPMethod
            functionName:(NSString *)theFunctionName
{
  self = [super init];

  if (self) {
    _functionName = theFunctionName;
    _HTTPMethod = theHTTPMethod;

    NSString *fullURL = [self urlWithoutParams];
    [self setUrlString:fullURL];
  }

  return self;
}

+ (id)urlWithHTTPMethod:(DSWebServiceURLHTTPMethod)theHTTPMethod
           functionName:(NSString *)theFunctionName
{
  DSWebServiceURL *url = [[DSWebServiceURL alloc] initWithHTTPMethod:theHTTPMethod
                                                        functionName:theFunctionName];

  return url;
}

#pragma mark - public
- (void)applyParams:(id<DSWebServiceParam>)theParams
{
  NSMutableString *urlStringWithParams = [[self urlWithoutParams] mutableCopy];

  if ([self HTTPMethod] != DSWebServiceURLHTTPMethodPOST) {
    NSMutableString *GETParams = [NSMutableString string];

    NSUInteger paramsCount = [[theParams stringParamNames] count];
    NSMutableArray *embeddedParams = [NSMutableArray array];

    __block NSUInteger paramIndex = 0;
    [theParams enumerateParamsAndParamNamesWithBlock:
                 ^void(id<DSWebServiceParam> param,
                       NSString *paramName)
                 {
                   NSString *value = [param stringValueForParamName:paramName];

                   if ([param embeddedIndex] == DSWebServiceParamEmbeddedIndexNotSet) {
                     NSString *string
                       = [NSString stringWithFormat:@"%@=%@",
                                                    paramName,
                                                    [value urlCompliantString]];
                     [GETParams appendString:string];

                     if (paramIndex < paramsCount - 1) {
                       [GETParams appendString:@"&"];
                     }
                   }
                   else {
                     [embeddedParams addObject:param];
                   }

                   paramIndex++;
                 }];

    //embed embedded params
    NSSortDescriptor *sortDescriptor
      = [NSSortDescriptor sortDescriptorWithKey:@"embeddedIndex"
                                      ascending:YES];

    NSArray *sortedEmbeddedParams
      = [embeddedParams sortedArrayUsingDescriptors:
                          [NSArray arrayWithObject:sortDescriptor]];

    for (id<DSWebServiceParam> param in sortedEmbeddedParams) {
      NSString
        *value = [param stringValueForParamName:[[param paramNames] objectAtIndex:0]];
      [urlStringWithParams appendFormat:@"/%@", value];
    }

    [urlStringWithParams appendString:@"?"];
    [urlStringWithParams appendString:GETParams];
  }
  else {//DSWebServiceURLHTTPMethodPOST
    DSWebServiceParamsExporter *paramsExporter
      = [[DSWebServiceParamsExporter alloc] initWithParams:theParams];
    NSData *paramsData = [paramsExporter exportParamsData];
    [self setParamsDataForPOST:paramsData];
    
    NSMutableArray *embeddedParams = [NSMutableArray array];
    [theParams enumerateParamsAndParamNamesWithBlock:
     ^void(id<DSWebServiceParam> param,
           NSString *paramName)
     {
       if ([param embeddedIndex] != DSWebServiceParamEmbeddedIndexNotSet) {
         [embeddedParams addObject:param];
       }
     }];
    
    //embed embedded params
    NSSortDescriptor *sortDescriptor
    = [NSSortDescriptor sortDescriptorWithKey:@"embeddedIndex"
                                    ascending:YES];
    
    NSArray *sortedEmbeddedParams
    = [embeddedParams sortedArrayUsingDescriptors:
       [NSArray arrayWithObject:sortDescriptor]];
    
    for (id<DSWebServiceParam> param in sortedEmbeddedParams) {
      NSString
      *value = [param stringValueForParamName:[[param paramNames] objectAtIndex:0]];
      [urlStringWithParams appendFormat:@"/%@", value];
    }

  }

  [self setUrlString:urlStringWithParams];
}

- (NSString *)description
{
  return [self urlString];
}

#pragma mark - helpers
- (NSString *)appendFunctionName:(NSString *)theFunction
                    toServerName:(NSString *)theServerName
{
  [theFunction length];
  unichar serverLastChar = [theServerName lastChar];
  unichar functionFirstChar = [theFunction firstChar];

  NSString *formatString = @"%@%@";

  if (serverLastChar == '/' && functionFirstChar == '/') {
    theFunction = [theFunction substringFromIndex:1];
    formatString = @"%@%@";
  }
  else if (serverLastChar != '/' && functionFirstChar != '/') {
    formatString = @"%@/%@";
  }

  NSString *formattedString = [NSString stringWithFormat:formatString,
                                                         theServerName, theFunction];
  return formattedString;
}


//===========================================================
//  Keyed Archiving
//
//===========================================================
- (void)encodeWithCoder:(NSCoder *)encoder
{
  [encoder encodeObject:self.urlString forKey:@"urlString"];
  [encoder encodeInt:self.HTTPMethod forKey:@"HTTPMethod"];
  [encoder encodeObject:self.functionName forKey:@"functionName"];
  [encoder encodeObject:self.paramsDataForPOST forKey:@"paramsDataForPOST"];
}

- (id)initWithCoder:(NSCoder *)decoder
{
  NSString *functionName = [decoder decodeObjectForKey:@"functionName"];
  DSWebServiceURLHTTPMethod HTTPMethod
    = (DSWebServiceURLHTTPMethod)[decoder decodeIntForKey:@"HTTPMethod"];
  self = [self initWithHTTPMethod:HTTPMethod functionName:functionName];

  if (self) {
    _urlString = [decoder decodeObjectForKey:@"urlString"];
    _paramsDataForPOST = [decoder decodeObjectForKey:@"paramsDataForPOST"];
  }
  return self;
}
@end
