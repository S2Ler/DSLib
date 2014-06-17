
#pragma mark - include
#import "DSWebServiceParamsExporter.h"
#import "DSWebServiceParamsJSONBuilder.h"
#import "DSWebServiceConfiguration.h"

#pragma mark - private
@interface DSWebServiceParamsExporter()
@property (nonatomic, strong) DSWebServiceCompositeParams *params;
@property (nonatomic, strong) id<DSWebServiceParamsBuilder> builder;

@property (nonatomic, assign) dispatch_queue_t callerDispatchQueue;
@property (nonatomic, copy) params_exported_handler_t completionHandler;
@property (nonatomic, strong) NSOperationQueue *exportingQueue;

@end

@implementation DSWebServiceParamsExporter
@synthesize params = _params;
@synthesize builder = _builder;
@synthesize callerDispatchQueue = _callerDispatchQueue;
@synthesize completionHandler = _completionHandler;
@synthesize exportingQueue = _exportingQueue;

- (void)dealloc
{
  [_exportingQueue setSuspended:YES];
  [_exportingQueue cancelAllOperations];
}

- (id<DSWebServiceParamsBuilder>)builderWithType:(NSString *)theBuilderType
{
  if ([theBuilderType isEqualToString:@"JSON"] == YES) {
    return [[DSWebServiceParamsJSONBuilder alloc] init];
  }
  else {
    NSAssert(FALSE, @"Handler %@ builder type", theBuilderType);
             
    return nil;
  }
}

- (id)initWithParams:(DSWebServiceCompositeParams *)theParams
             builder:(id<DSWebServiceParamsBuilder>)theBuilder
{
  self = [super init];
  
  if (self) {
    _params = theParams;
    _builder = theBuilder;
    _exportingQueue = [[NSOperationQueue alloc] init];
    [_exportingQueue setMaxConcurrentOperationCount:1];
    [_exportingQueue setSuspended:NO];
  }
  
  return self;
}

- (id)initWithParams:(DSWebServiceCompositeParams *)theParams
{
  NSString *builderType = [[DSWebServiceConfiguration sharedInstance] paramsDataOutputType];
  id<DSWebServiceParamsBuilder> builder = [self builderWithType:builderType];
  return [self initWithParams:theParams builder:builder];
}

- (void)importParams:(id<DSWebServiceParam>)theParams
           toBuilder:(id<DSWebServiceParamsBuilder>)theBuilder
{
  void (^handle_value)(id<DSWebServiceParam> value, NSString *key) = 
  ^(id<DSWebServiceParam> param, NSString *key){
    if ([param paramType] == DSWebServiceParamTypeString) {
      [theBuilder addParamWithKey:key value:[param stringValueForParamName:nil]];
    }
    else if ([param paramType] == DSWebServiceParamTypeArray) {
      [theBuilder startArrayLeafWithName:key];
      [self importParams:param toBuilder:theBuilder];
      [theBuilder endLeaf];
    }
    else if ([param paramType] == DSWebServiceParamTypeDictionary) {
      [theBuilder startDictionaryLeafWithName:key];
      [self importParams:param toBuilder:theBuilder];
      [theBuilder endLeaf];
    }
    else {
      NSAssert(FALSE, @"Handle this situation");
    }
  };
  
  
  if ([theParams paramType] == DSWebServiceParamTypeDictionary) {
    [theParams enumerateParamsAndParamNamesWithBlock:
     ^(id<DSWebServiceParam> param, NSString *paramName) {
       handle_value(param, paramName);
     }];
  }
  else if ([theParams paramType] == DSWebServiceParamTypeArray) {
    [theParams enumerateParamsAndParamNamesWithBlock:
     ^(id<DSWebServiceParam> param, NSString *paramName) {
       handle_value(param, nil);
     }];
  }
  else if ([theParams paramType] == DSWebServiceParamTypeString) {
    handle_value(theParams, nil);
  }
}

- (NSData *)exportParamsData
{
  id<DSWebServiceParamsBuilder> builder = [self builder];
  [builder startParamsOutput];
  
  [self importParams:[self params]
           toBuilder:builder];
  
  [builder endParamsOutput];
  
  NSData *paramsData = [builder params];

  return paramsData;
}

- (void)exportParams
{
  @autoreleasepool {    
    NSData *paramsData = [self exportParamsData];
    
    dispatch_async([self callerDispatchQueue], ^{
      [self completionHandler](paramsData);
    });
  }    
}

- (void)exportWithCompletionHandler:(params_exported_handler_t)theHandler
{
  [self setCompletionHandler:theHandler];
  [self setCallerDispatchQueue:dispatch_get_main_queue()];
  
  NSOperation *exportOperation 
  = [[NSInvocationOperation alloc] initWithTarget:self 
                                         selector:@selector(exportParams)     
                                           object:nil];
  [[self exportingQueue] addOperation:exportOperation];  
}
@end
