#pragma mark - include
#import "DSWebServiceCompositeParams.h"
#import "DSWebServiceStringParam.h"

#pragma mark - private
@interface DSWebServiceCompositeParams ()
@property (nonatomic, strong) NSMutableDictionary *params;
@end

@implementation DSWebServiceCompositeParams

@synthesize userInfo = _userInfo;
@synthesize params = _params;
@synthesize embeddedIndex = _embeddedIndex;

- (void)dealloc
{
}

- (id)init
{
  self = [super init];
  if (self) {
    _params = [[NSMutableDictionary alloc] init];
    _embeddedIndex = DSWebServiceParamEmbeddedIndexNotSet;
  }

  return self;
}

- (id<DSWebServiceParam>)stringParamWithValue:(NSString *)theValue
                                    paramName:(NSString *)theName
{
  id<DSWebServiceParam> stringParam = [[DSWebServiceStringParam alloc] init];

  [stringParam addStringValue:theValue forParamName:theName];

  return stringParam;
}

- (id<DSWebServiceParam>)addStringValue:(NSString *)theValue
          forParamName:(NSString *)theParamName
{
  if (theValue == nil) {
    theValue = @"";
  }

  id<DSWebServiceParam>
    param = [self stringParamWithValue:theValue paramName:theParamName];
  [self addParam:param forParamName:theParamName];

  return param;
}

- (NSArray *)paramNames
{
  return [[self params] allKeys];
}

- (NSArray *)stringParamNames
{
  NSMutableArray *stringParamNames = [NSMutableArray array];

  [self enumerateStringValuesAndParamNamesWithBlock:
          ^(NSString *param, NSString *value)
          {
            [stringParamNames addObject:param];
          }];
  return stringParamNames;
}

- (NSString *)stringValueForParamName:(NSString *)theParamName
{
  NSAssert(theParamName != nil, @"theParam shouldn't be nil");

  if (theParamName) {
    id<DSWebServiceParam> param = [self paramForParamName:theParamName];

    if ([param isKindOfClass:[DSWebServiceStringParam class]] == YES) {
      return [param stringValueForParamName:theParamName];
    }
    else {
      return nil;
    }
  }
  else {
    return nil;
  }
}

- (void)addParam:(id<DSWebServiceParam>)theParam
    forParamName:(NSString *)theName
{
  [[self params] setValue:theParam forKey:theName];
}

- (id<DSWebServiceParam>)paramForParamName:(NSString *)theParamName
{
  return [[self params] valueForKey:theParamName];
}

- (NSString *)description
{
  return [NSString stringWithFormat:@"%@", [self params]];
}

- (void)enumerateParamsAndParamNamesWithBlock:(void (^)(id<DSWebServiceParam> param,
                                                        NSString *paramName))theBlock
{
  NSArray *params = [self paramNames];

  for (NSString *paramName in params) {
    id<DSWebServiceParam> param = [self paramForParamName:paramName];

    if (param) {
      theBlock(param, paramName);
    }
  }
}

- (void)enumerateStringValuesAndParamNamesWithBlock:(void (^)(NSString *theParamName,
                                                              NSString *value))theBlock
{
  [self enumerateParamsAndParamNamesWithBlock:
          ^(id<DSWebServiceParam> param, NSString *paramName)
          {
            if ([param isKindOfClass:[DSWebServiceStringParam class]] == YES) {
              NSString *stringValue = [param stringValueForParamName:paramName];
              if (stringValue) {
                theBlock(paramName, stringValue);
              }
            }
          }];
}

- (DSWebServiceParamType)paramType
{
  return DSWebServiceParamTypeDictionary;
}


//===========================================================
//  Keyed Archiving
//
//===========================================================
- (void)encodeWithCoder:(NSCoder *)encoder
{
  [encoder encodeObject:self.params forKey:@"params"];
  [encoder encodeInteger:self.embeddedIndex forKey:@"embeddedIndex"];
  [encoder encodeObject:self.userInfo forKey:@"userInfo"];
}

- (id)initWithCoder:(NSCoder *)decoder
{
  self = [super init];
  if (self) {
    self.params = [decoder decodeObjectForKey:@"params"];
    self.embeddedIndex = [decoder decodeIntegerForKey:@"embeddedIndex"];
    self.userInfo = [decoder decodeObjectForKey:@"userInfo"];
  }
  return self;
}
@end
