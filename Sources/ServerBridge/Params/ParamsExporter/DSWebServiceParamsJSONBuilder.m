//
//  DSWebServiceParamsJSONBuilder.m
//
//  Created by Alexander Belyavskiy on 2/29/12.
//

#pragma mark - include
#import "DSWebServiceParamsJSONBuilder.h"
#import "JSONKit.h"
#import <objc/runtime.h>

#pragma mark - private
@interface DSWebServiceParamsJSONBuilder()
/** To be converted to JSON at the end of building phase */
@property (nonatomic, strong) NSMutableDictionary *paramsDictionary;
@property (nonatomic, strong) id currentLeaf;

/** Used to test balancing startLeaf, endLeaf methods */
@property (nonatomic, assign) NSInteger openCloseCounter;

- (void)checkConsistency;
- (void)checkFinalConsistency;
@end

@implementation DSWebServiceParamsJSONBuilder
@synthesize params = _params;
@synthesize paramsDictionary = _paramsDictionary;
@synthesize currentLeaf = _currentLeaf;
@synthesize openCloseCounter = _openCloseCounter;

static char PREV_LEAF_KEY;

+ (id)builder
{
  return [[self alloc] init];
}

- (void)startParamsOutput
{
  [self setParamsDictionary:[[NSMutableDictionary alloc] init]];  
  [self setCurrentLeaf:[self paramsDictionary]];
}

- (void)setPreviousLeaf:(id)thePreviousLeaf forLeaf:(id)theLeaf
{
  objc_setAssociatedObject(theLeaf, &PREV_LEAF_KEY, thePreviousLeaf, OBJC_ASSOCIATION_ASSIGN);
}

- (id)previousLeafForLeaf:(id)theLeaf
{
  return objc_getAssociatedObject(theLeaf, &PREV_LEAF_KEY);
}

- (void)__addLeaf:(id)theLeaf withName:(NSString *)theName
{  
  if (theName == nil && [[self currentLeaf] isKindOfClass:[NSDictionary class]] == YES) {
    return;
  }
    
  [self setOpenCloseCounter:_openCloseCounter+1];  
  
  if ([[self currentLeaf] isKindOfClass:[NSDictionary class]] == YES) {
    [[self currentLeaf] setValue:theLeaf forKey:theName];
  }
  else if ([[self currentLeaf] isKindOfClass:[NSArray class]] == YES) {
    [[self currentLeaf] addObject:theLeaf];
  }
  
  [self setPreviousLeaf:[self currentLeaf] forLeaf:theLeaf];
  [self setCurrentLeaf:theLeaf];  
}

- (void)startDictionaryLeafWithName:(NSString *)theName
{  
  NSMutableDictionary *newLeaf = [NSMutableDictionary dictionary];
  [self __addLeaf:newLeaf withName:theName];
}

- (void)startArrayLeafWithName:(NSString *)theName
{
  NSMutableArray *newLeaf = [NSMutableArray array];
  [self __addLeaf:newLeaf withName:theName];
}

- (void)addParamWithKey:(NSString *)theKey value:(NSString *)theValue
{
  if (theKey == nil && [[self currentLeaf] isKindOfClass:[NSDictionary class]] == YES) return;
    
  if ([[self currentLeaf] isKindOfClass:[NSDictionary class]] == YES) {
    [[self currentLeaf] setValue:theValue forKey:theKey];
  }
  else if ([[self currentLeaf] isKindOfClass:[NSArray class]] == YES) {
    [[self currentLeaf] addObject:theValue];
  }
}

- (void)endLeaf
{
  id previousLeaf = [self previousLeafForLeaf:[self currentLeaf]];
  if (previousLeaf != nil) {
    [self setCurrentLeaf:previousLeaf];
  }
  
  [self setOpenCloseCounter:_openCloseCounter-1];
  
  [self checkConsistency];
}

- (void)endParamsOutput
{
  [self checkFinalConsistency];
  [self setParams:[[self paramsDictionary] JSONData]];
}

- (void)checkConsistency
{
  if ([self openCloseCounter] < 0) {
    [NSException raise:NSInternalInconsistencyException 
                format:@"startLeaf, endLeaf methods isn't balanced; openCloseCounter = %d", 
     [self openCloseCounter]];
    return;
  }
}

- (void)checkFinalConsistency
{
  if ([self openCloseCounter] != 0) {
    [NSException raise:NSInternalInconsistencyException 
                format:@"startLeaf, endLeaf methods isn't balanced"];
    return;
  }
}
@end
