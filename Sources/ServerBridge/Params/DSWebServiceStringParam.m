
#pragma mark - include
#import "DSWebServiceStringParam.h"

#pragma mark - private
@interface DSWebServiceStringParam()
@property (nonatomic, strong) NSString *paramName;
@property (nonatomic, strong) NSString *value;
@end

@implementation DSWebServiceStringParam
@synthesize paramName = _paramName;
@synthesize value = _value;
@synthesize userInfo = _userInfo;
@synthesize embeddedIndex = _embeddedIndex;

- (id)init
{
  self = [super init];

  if (self) {
    _embeddedIndex = DSWebServiceParamEmbeddedIndexNotSet;
  }

  return self;
}

- (id<DSWebServiceParam>)addStringValue:(NSString *)theValue
          forParamName:(NSString *)theParam
{
  [self setValue:theValue];
  [self setParamName:theParam];

  return self;
}

- (NSArray *)paramNames
{
  if ([self paramName] == nil) {
    return nil;
  }
  else {
    return [NSArray arrayWithObject:[self paramName]];
  }
}

- (NSArray *)stringParamNames
{
  return [self paramNames];
}

- (NSString *)stringValueForParamName:(NSString *)theParam
{
  if ([self paramName] == nil || theParam == nil) return [self value];
  
  if ([theParam isEqualToString:[self paramName]] == YES) {
    return [self value];
  }
  else {
    return nil;
  }
}

- (void)enumerateStringValuesAndParamNamesWithBlock:(void(^)(NSString *param, NSString *value))theBlock
{
  theBlock([self paramName], [self value]);
}

- (void)enumerateParamsAndParamNamesWithBlock:(void (^)(id<DSWebServiceParam> param, NSString *paramName))theBlock
{
  theBlock(self, [self paramName]);
}

- (void)addParam:(id<DSWebServiceParam>)theParam
    forParamName:(NSString *)theName
{
  NSAssert(FALSE, @"DSWebServiceStringParam doesn't support composite methods");
}

- (id<DSWebServiceParam>)paramForParamName:(NSString *)theParamName
{
  NSAssert(FALSE, @"DSWebServiceStringParam doesn't support composite methods");
  return nil;
}

- (NSString *)description
{
  return [NSString stringWithFormat:@"%@", [self value]];
}

- (DSWebServiceParamType)paramType
{
  return DSWebServiceParamTypeString;
}


//===========================================================
//  Keyed Archiving
//
//===========================================================
- (void)encodeWithCoder:(NSCoder *)encoder
{
  [encoder encodeObject:self.paramName forKey:@"paramName"];
  [encoder encodeObject:self.value forKey:@"value"];
  [encoder encodeInteger:self.embeddedIndex forKey:@"embeddedIndex"];
  [encoder encodeObject:self.userInfo forKey:@"userInfo"];
}

- (id)initWithCoder:(NSCoder *)decoder
{
  self = [super init];
  if (self) {
    self.paramName = [decoder decodeObjectForKey:@"paramName"];
    self.value = [decoder decodeObjectForKey:@"value"];
    self.embeddedIndex = [decoder decodeIntegerForKey:@"embeddedIndex"];
    self.userInfo = [decoder decodeObjectForKey:@"userInfo"];
  }
  return self;
}
@end
