
#pragma mark - include
#import "DSWebServiceResponse.h"
#import "JSONKit.h"
#import "DSMessage.h"
#import "DSCFunctions.h"
#import "NSError+DSWebService.h"

#import "DSMacros.h"

#pragma mark - props
@interface DSWebServiceResponse ()

@property (nonatomic, strong) NSDictionary *parsedDocument;
@property (assign) BOOL parseCalled;

@property (nonatomic, strong) NSData *data;
@property (nonatomic, strong) NSString *path;
@end


@implementation DSWebServiceResponse

#pragma mark - init
- (id)initWithData:(NSData *)theData
{
  self = [super init];
  
  if (self) {
    [self setData:theData];
  }
  
  return self;
}

- (id)container
{
  return [self responseDictionary];
}

+ (id)responseWithData:(NSData *)theData
{
  DSWebServiceResponse *response 
  = [[DSWebServiceResponse alloc] initWithData:theData];
  
  return response;
}

- (id)initWithResponse:(DSWebServiceResponse *)response
{
  self = [super init];
  if (self) {
    _data = [response data];
    _parsedDocument = [response parsedDocument];
    _parseCalled = [response parseCalled];
    _path = [response path];
  }
  return self;
}

+ (id)responseWithResponse:(DSWebServiceResponse *)response
{
  id newResponse = [[self alloc] initWithResponse:response];
  return newResponse;
}

- (instancetype)initWithPath:(NSString *)path
{
  self = [super init];
  if (self) {
    _path = path;
  }
  return self;
}

+ (instancetype)responseWithPath:(NSString *)path
{
  return [[self alloc] initWithPath:path];
}

- (NSData *)data
{
  if (_data) {
    return _data;
  }
  
  if (_path) {
    _data = [NSData dataWithContentsOfMappedFile:_path];
    return _data;
  }
  
  return _data;  
}

#pragma mark - public
- (BOOL)parse
{
  [self setParseCalled:YES];
  
  NSDictionary *doc = [[self data] objectFromJSONData];  
  
  if (!doc) {
    NSLog(@"Failed to parse JSON");
  }
  
  if (!doc) {
    return NO;
  }
  
  [self setParsedDocument:doc];
  
  return YES;
}

- (NSDictionary *)responseDictionary
{
  if (![self parseCalled]) {
    [self setParseCalled:YES];
    [self parse];
  }
  
  return [self parsedDocument];
}

- (NSString *)description
{
  return [NSString stringWithFormat:@"ParsedDocument: %@", [[[self data] objectFromJSONData] JSONString]];
}

@end

@implementation DSWebServiceResponse (Abstract)

- (BOOL)isServerResponse
{
  return [self responseDictionary] != nil;
}

- (NSString *)keypathForGetter:(NSString *)getter
{
  ASSERT_ABSTRACT_METHOD;
  return nil;
}

- (BOOL)isSuccessfulResponse
{
  ASSERT_ABSTRACT_METHOD;
  return NO;
}

- (NSString *)errorCode
{
  ASSERT_ABSTRACT_METHOD;
  return nil;
}

- (DSMessage *)APIErrorMessage
{
  DSMessageCode *statusCode = [self errorCode];
  DSMessageDomain *errorDomain = kDSMessageDomainWebService;

  DSMessage *errorMessage = [DSMessage messageWithDomain:errorDomain
                                                    code:statusCode];

  return errorMessage;
}



@end
