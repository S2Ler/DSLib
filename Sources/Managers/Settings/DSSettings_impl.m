
#pragma mark - include
#import "DSSettings_impl.h"
#import "DSRuntimeHacker.h"

#pragma mark - private
@interface DSSettings_impl ()
@property (nonatomic, strong) NSArray *observedValues;
- (void)setupObserving;

/** The idea is to remove internal properties from list of properties */
- (NSArray *)filterPropertyNamesFromHacker:(NSArray *)thePropertyNames;

- (void)loadSavedValues;

- (void)saveObject:(id)theObject forKey:(NSString *)theKey;
- (id)savedObjectForKey:(NSString *)theKey;
@end

@implementation DSSettings_impl
@synthesize observedValues = _observedValues;

- (void)endObserving
{
  NSArray *allSettingsNames = [self observedValues];
  
  for (NSString *settingName in allSettingsNames) {
    [self removeObserver:self
              forKeyPath:settingName
                 context:nil];
  }  
}

- (void)dealloc
{
  [self endObserving];  
}

#pragma mark - init
- (NSArray *)filterPropertyNamesFromHacker:(NSArray *)thePropertyNames
{
  NSMutableArray *filteredNames = [NSMutableArray array];

  for (NSString *propertyName in thePropertyNames) {
    if (![propertyName hasPrefix:@"_"]) {
      [filteredNames addObject:propertyName];
    }
  }

  return filteredNames;
}

- (void)loadSavedValues
{
  NSArray *allSettingsNames = [[DSRuntimeHacker hackerWithClient:self] allPropertyNames];
  allSettingsNames = [self filterPropertyNamesFromHacker:allSettingsNames];

  for (NSString *settingName in allSettingsNames) {
    id savedValue = [self savedObjectForKey:settingName];
    id actualValue = [self valueForKey:settingName];
    
    /* NOTE: for primitive values if you try to setValue:NIL_VALUE forKey: you
     will get exception, to prevent this we check like this as actualValue in
     this case will be not nil. */
    if(savedValue == nil && actualValue != nil) {
      savedValue = actualValue;
    }
     
    [self setValue:savedValue
            forKey:settingName];
  }  
}

- (void)setupObserving
{
  NSArray *allSettingsNames = [[DSRuntimeHacker hackerWithClient:self] allPropertyNames];
  allSettingsNames = [self filterPropertyNamesFromHacker:allSettingsNames];

  [self setObservedValues:allSettingsNames];
  
  for (NSString *settingName in allSettingsNames) {
    [self addObserver:self
           forKeyPath:settingName
              options:NSKeyValueObservingOptionNew
              context:nil];
  }  
}

- (id)init
{
  self = [super init];
  if (self) {
    [self loadSavedValues];
    [self setupObserving];
  }
  return self;
}

- (NSString *)settingsPrefix
{
    return NSStringFromClass([self class]);
}

- (NSString *)saveKeyFromKey:(NSString *)key
{
  return [[self settingsPrefix] stringByAppendingFormat:@"_%@", key];
}

- (void)saveObject:(id)theObject forKey:(NSString *)theKey
{
  if ([theObject isEqual:[NSNull null]]) {
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:[self saveKeyFromKey:theKey]];
    [[NSUserDefaults standardUserDefaults] synchronize];
    return;
  }

  if ([theObject conformsToProtocol:@protocol(NSCoding)]) {
    theObject = [NSKeyedArchiver archivedDataWithRootObject:theObject];
  }
  
  [[NSUserDefaults standardUserDefaults] setObject:theObject
                                            forKey:[self saveKeyFromKey:theKey]];
  [[NSUserDefaults standardUserDefaults] synchronize];
}

- (id)savedObjectForKey:(NSString *)theKey
{
  if (theKey != nil) {    
    id object = [[NSUserDefaults standardUserDefaults] objectForKey:[self saveKeyFromKey:theKey]];
    if ([object isKindOfClass:[NSData class]]) {
      object = [NSKeyedUnarchiver unarchiveObjectWithData:object];
    }
    
    return object;  
  }
  else {
    return nil;
  }
}

- (void)observeValueForKeyPath:(NSString *)keyPath 
                      ofObject:(id)object
                        change:(NSDictionary *)change 
                       context:(void *)context
{
  if (context == nil) {
    id newValue = [change objectForKey:NSKeyValueChangeNewKey];
    [self saveObject:newValue forKey:keyPath];
  } 
  else {
    [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
  }
}

- (void)setObject:(id)object forKey:(NSString *)key
{
  [self saveObject:object forKey:key];
}

- (id)objectForKey:(NSString *)key
{
  return [self savedObjectForKey:key];
}

@end
