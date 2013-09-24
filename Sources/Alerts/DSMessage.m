
#pragma mark - include
#import "DSMessage.h"

#define LOCALIZATION_TABLE @"DSMessagesLocalization"

#pragma mark - private
@interface DSMessage ()
@property (nonatomic, strong) DSMessageDomain *domain;
@property (nonatomic, strong) DSMessageCode *code;
@property (nonatomic, retain) NSArray *params;
@end

@implementation DSMessage

- (NSString *)keyForLocalizedTitle
{
  NSString *key = [NSString stringWithFormat:@"%@.%@.title", [self domain], [self code]];
  return key;
}

- (NSString *)keyForLocalizedBody
{
  NSString *key = [NSString stringWithFormat:@"%@.%@.body", [self domain], [self code]];
  return key;
}

- (NSString *)localizedTitle
{
  NSString *localizationKey = [self keyForLocalizedTitle];
  NSString *title = NSLocalizedStringFromTable(localizationKey, LOCALIZATION_TABLE, nil);
  
  return title;
}

- (NSString *)localizedBody
{
  NSString *localizationKey = [self keyForLocalizedBody];
  NSString *body = NSLocalizedStringFromTable(localizationKey, LOCALIZATION_TABLE, nil);
  
  if ([[self params] count] > 0) {
    NSRange range = NSMakeRange(0, [[self params] count]);
    
    NSMutableData* data = [NSMutableData dataWithLength: sizeof(id) * [[self params] count]];
    
    [[self params] getObjects: (__unsafe_unretained id *)data.mutableBytes range:range];
    
    
    return [[NSString alloc] initWithFormat:body arguments:[data mutableBytes]];
  }
  else {
    return body;
  }
}

- (id)initWithDomain:(DSMessageDomain *)theDomain
                code:(DSMessageCode *)theCode
              params:(id)theParam, ...
{
  self = [super init];
  if (self) {
    _domain = [theDomain copy];
    _code = theCode;

    va_list params;
    va_start(params, theParam);

    NSMutableArray *paramsArray = [NSMutableArray array];
    for (id param = theParam; param != nil; param = va_arg(params, id)) {
      [paramsArray addObject:param];
    }
    va_end(params);

    _params = [paramsArray copy];
  }

  return self;
}

- (id)initWithDomain:(DSMessageDomain *)theDomain code:(DSMessageCode *)theCode
{
  return [self initWithDomain:theDomain
                         code:theCode
                       params:nil];
}

+ (id)messageWithDomain:(DSMessageDomain *)theDomain code:(DSMessageCode *)theCode
{
  DSMessage *message = [[DSMessage alloc] initWithDomain:theDomain
                                                  code:theCode];
  return message;
}

- (id)initWithError:(NSError *)theError
{
  NSString *domain = [theError domain];
  NSInteger code = [theError code];

  return [self initWithDomain:domain
                         code:[NSString stringWithFormat:@"%d", code]];
}

+ (id)messageWithError:(NSError *)theError
{
  DSMessage *message = [[DSMessage alloc] initWithError:theError];
  return message;
}


- (BOOL)isEqualToMessage:(DSMessage *)theObj
{
  BOOL incomeObjectIncorrect = (theObj == nil) || ([theObj isKindOfClass:[self class]] == NO);

  if (incomeObjectIncorrect == YES) {
    return NO;
  }

  BOOL domainsEqual = [[self domain] isEqualToString:[theObj domain]];
  BOOL codesEqual = [[self code] isEqualToString:[theObj code]];
  BOOL paramsEqual = YES;
  for (id param in [self params]) {
    for (id comparedParam in [theObj params]) {
      if (!paramsEqual) {
        break;
      }

      if (![param isEqual:comparedParam]) {
        paramsEqual = NO;
        break;
      }
    }
  }

  return (domainsEqual && codesEqual && paramsEqual);
}

- (NSString *)description
{
  NSString *str = [NSString stringWithFormat:@"domain: %@; code: %@",
                                             [self domain], [self code]];
  return str;
}
@end
