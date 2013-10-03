
#pragma mark - include
#import "DSWebServiceResponse.h"
#import "JSONKit.h"
#import "DSMessage.h"
#import "DSCFunctions.h"
#import "NSError+DSWebService.h"

#pragma mark - props
@interface DSWebServiceResponse ()

@property (nonatomic, strong) NSDictionary *parsedDocument;
@property (assign) BOOL parseCalled;
@end

#pragma mark - props
@interface DSWebServiceResponse ()
@property (nonatomic, retain) NSData *data;
@end

#pragma mark - private
@interface DSWebServiceResponse (Private)
@end

@implementation DSWebServiceResponse
#pragma mark - synth

@synthesize parsedDocument = _parsedDocument;

@synthesize data = _data;

- (void)dealloc 
{
}

#pragma mark - init
- (id)initWithData:(NSData *)theData
{
  self = [super init];
  
  if (self) {
    [self setData:theData];
  }
  
  return self;
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
  }
  return self;
}

+ (id)responseWithResponse:(DSWebServiceResponse *)response
{
  id newResponse = [[self alloc] initWithData:[response data]];
  [newResponse parse];
  return newResponse;
}

#pragma mark - public
- (BOOL)parse
{
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
