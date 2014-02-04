
#pragma mark - include
#import "DSWebServiceResponse.h"
#import "JSONKit.h"
#import "DSMessage.h"
#import "DSCFunctions.h"
#import "NSError+DSWebService.h"
#import "MARTNSObject.h"
#import "RTProperty.h"
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

#pragma mark - dynamic properties
- (void)forwardInvocation:(NSInvocation *)anInvocation
{
  NSString *getterName = NSStringFromSelector([anInvocation selector]);
  
  NSInteger lastParamIndex = 1;
  [anInvocation setArgument:&getterName atIndex:lastParamIndex + 1];
  
  NSString *type = [self typeForPropertyWithName:getterName];
  if ([type hasPrefix:@"@"]) {
    [anInvocation setSelector:@selector(handleObjectGetterWithName:)];
  }
  else if ([type hasPrefix:@"I"]) {
    [anInvocation setSelector:@selector(handleUnsignedIntegerWithName:)];
  }
  else if ([type hasPrefix:@"Q"]) {
    [anInvocation setSelector:@selector(handleUnsignedLongLongWithName:)];
  }
  UNHANDLED_IF;
  
  [anInvocation invokeWithTarget:self];
}

- (NSString *)typeForPropertyWithName:(NSString *)propertyName
{
  RTProperty *property = [[self class] rt_propertyForName:propertyName];
  NSAssert([property isReadOnly], @"Custom accessors to response dictionary should be readonly properties");
  if (property) {
    NSString *typeEncoding = [property typeEncoding];
    return typeEncoding;
  }
  return nil;
}

+ (NSNumberFormatter *)numberFormatter
{
  DEFINE_SHARED_INSTANCE_USING_BLOCK(^{
    return [[NSNumberFormatter alloc] init];
  });
}

- (NSNumber *)numberForPropertyName:(NSString *)propertyName
{
  id numberObject = [[self responseDictionary] valueForKeyPath:[self keypathForGetter:propertyName]];
  NSNumber *number = nil;
  
  if ([numberObject isKindOfClass:[NSNumber class]]) {
    number = numberObject;
  }
  else if ([numberObject isKindOfClass:[NSString class]]) {
    number = [[[self class] numberFormatter] numberFromString:numberObject];
  }
  return number;
}

- (NSUInteger)handleUnsignedIntegerWithName:(NSString *)propertyName
{
  NSNumber *number = [self numberForPropertyName:propertyName];
  return [number unsignedIntegerValue];
}

- (unsigned long long)handleUnsignedLongLongWithName:(NSString *)propertyName
{
  NSNumber *number = [self numberForPropertyName:propertyName];
  return [number unsignedLongLongValue];
}

/** \param theSetter looks like: setParamName */
- (id)handleObjectGetterWithName:(NSString *)getterName
{
  NSString *value = [[self responseDictionary] valueForKeyPath:[self keypathForGetter:getterName]];
  return value;
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)selector
{
  NSMethodSignature *signature = [super methodSignatureForSelector:selector];
  
  if (!signature) {
    NSString *typeEncoding = [self typeForPropertyWithName:NSStringFromSelector(selector)];
    if (typeEncoding) {
      signature = [NSMethodSignature signatureWithObjCTypes:[[NSString stringWithFormat:@"%@@:@", typeEncoding]cStringUsingEncoding:NSUTF8StringEncoding]];
    }
  }
  
  return signature;
}

@end
