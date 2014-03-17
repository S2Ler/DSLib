#pragma mark - include
#import "DSWebServiceURL.h"
#import "DSWebServiceCompositeParams.h"
#import "DSWebServiceConfiguration.h"
#import "DSWebServiceFunctions.h"
#import "DSWebServiceParamsExporter.h"
#import "NSString+Encoding.h"
#import "NSString+Extras.h"

#pragma mark - props
@interface DSWebServiceURL ()

@property (nonatomic, strong) NSString *urlString;
@property (nonatomic, strong) NSData *paramsDataForPOST;
@property (nonatomic, strong) NSString *functionName;
@property (nonatomic, assign) BOOL forceHTTPS;
@property (nonatomic, strong) NSString *customServerURL;
@end

#pragma mark - private
@interface DSWebServiceURL (Private)
- (NSString *)appendFunctionName:(NSString *)theFunction
                    toServerName:(NSString *)theServerName;
@end

@implementation DSWebServiceURL

#pragma mark - init
- (id)init
{
  return [self initWithHTTPMethod:DSWebServiceURLHTTPMethodGET
                     functionName:nil
                       forceHTTPS:NO];
}

- (NSString *)urlWithoutParamsForceHTTPS:(BOOL)forceHTTPS
{
  NSMutableString *serverURL;
  if ([self customServerURL]) {
    serverURL = [[self customServerURL] mutableCopy];
  }
  else {
    serverURL = [[[DSWebServiceConfiguration sharedInstance] serverURL] mutableCopy];
  }
  
  BOOL HTTPSEnabled = [[DSWebServiceConfiguration sharedInstance] HTTPSEnabled];
  
  if ((HTTPSEnabled || forceHTTPS) && ![serverURL hasPrefix:@"https://"]) {
    if ([serverURL hasPrefix:@"http://"]) {
      [serverURL replaceOccurrencesOfString:@"http://"
                                 withString:@"https://"
                                    options:NSAnchoredSearch
                                      range:NSMakeRange(0, [serverURL length])];
    }
    else {
      [serverURL insertString:@"https://" atIndex:0];
    }
  }
  else if (!HTTPSEnabled && !forceHTTPS && ![serverURL hasPrefix:@"http://"]) {
    if ([serverURL hasPrefix:@"https://"]) {
      [serverURL replaceOccurrencesOfString:@"https://"
                                 withString:@"http://"
                                    options:NSAnchoredSearch
                                      range:NSMakeRange(0, [serverURL length])];
    }
    else {
      [serverURL insertString:@"http://" atIndex:0];
    }
  }
  
  return [self appendFunctionName:[self functionName]
                     toServerName:serverURL];
}

- (NSString *)urlWithoutParams
{
  return [self urlWithoutParamsForceHTTPS:[self forceHTTPS]];
}

- (id)initWithHTTPMethod:(DSWebServiceURLHTTPMethod)theHTTPMethod
            functionName:(NSString *)theFunctionName
              forceHTTPS:(BOOL)forceHTTPS
         customServerURL:(NSString *)serverURL
{
  self = [super init];

  if (self) {
    _functionName = theFunctionName;
    _HTTPMethod = theHTTPMethod;
    _forceHTTPS = forceHTTPS;
    _customServerURL = serverURL;

    NSString *fullURL = [self urlWithoutParams];
    [self setUrlString:fullURL];
  }

  return self;
}

- (id)initWithHTTPMethod:(DSWebServiceURLHTTPMethod)theHTTPMethod
            functionName:(NSString *)theFunctionName
              forceHTTPS:(BOOL)forceHTTPS
{
  return [self initWithHTTPMethod:theHTTPMethod functionName:theFunctionName forceHTTPS:forceHTTPS customServerURL:nil];
}

+ (id)urlWithHTTPMethod:(DSWebServiceURLHTTPMethod)theHTTPMethod
           functionName:(NSString *)theFunctionName
             forceHTTPS:(BOOL)forceHTTPS
        customServerURL:(NSString *)serverURL
{
  DSWebServiceURL *url = [[DSWebServiceURL alloc] initWithHTTPMethod:theHTTPMethod
                                                        functionName:theFunctionName
                                                          forceHTTPS:forceHTTPS
                                                     customServerURL:serverURL];
  
  return url;
}

+ (id)urlWithHTTPMethod:(DSWebServiceURLHTTPMethod)theHTTPMethod
           functionName:(NSString *)theFunctionName
             forceHTTPS:(BOOL)forceHTTPS
{
  DSWebServiceURL *url = [[DSWebServiceURL alloc] initWithHTTPMethod:theHTTPMethod
                                                        functionName:theFunctionName
                                                          forceHTTPS:forceHTTPS];

  return url;
}

#pragma mark - public
- (void)applyParams:(id<DSWebServiceParam>)theParams
{
  NSMutableString *urlStringWithParams = [[self urlWithoutParams] mutableCopy];

  if (YES || [self HTTPMethod] != DSWebServiceURLHTTPMethodPOST) {
    NSMutableString *GETParams = [NSMutableString string];

    NSUInteger paramsCount = [[theParams stringParamNames] count];
    NSMutableArray *embeddedParams = [NSMutableArray array];

    __block NSUInteger paramIndex = 0;
    [theParams enumerateParamsAndParamNamesWithBlock:
                 ^void(id<DSWebServiceParam> param, NSString *paramName)
                 {
                   NSString *value = [param stringValueForParamName:paramName];

                   if ([param embeddedIndex] == DSWebServiceParamEmbeddedIndexNotSet) {
                     NSString *string = [NSString stringWithFormat:@"%@=%@", paramName, [value urlCompliantString]];
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
  [encoder encodeBool:self.forceHTTPS forKey:@"forceHTTPS"];
}

- (id)initWithCoder:(NSCoder *)decoder
{
  NSString *functionName = [decoder decodeObjectForKey:@"functionName"];
  DSWebServiceURLHTTPMethod HTTPMethod
    = (DSWebServiceURLHTTPMethod)[decoder decodeIntForKey:@"HTTPMethod"];
  BOOL forceHTTPS = [decoder decodeBoolForKey:@"forceHTTPS"];
  self = [self initWithHTTPMethod:HTTPMethod functionName:functionName forceHTTPS:forceHTTPS];

  if (self) {
    _urlString = [decoder decodeObjectForKey:@"urlString"];
    _paramsDataForPOST = [decoder decodeObjectForKey:@"paramsDataForPOST"];
  }
  return self;
}
@end
