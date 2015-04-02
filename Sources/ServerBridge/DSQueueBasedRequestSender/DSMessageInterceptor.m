//
//  DSMessageInterceptor.m
//  DSLib
//
//  Created by Alexander Belyavskiy on 3/30/14.
//  Copyright (c) 2014 DS ltd. All rights reserved.
//

#import "DSMessageInterceptor.h"
#import "DSWebServiceParams.h"

@interface DSMessageInterceptor ()
@property (nonatomic, strong) NSMutableArray *excludedParams;
@end

@implementation DSMessageInterceptor

- (NSMutableArray *)excludedParams
{
  if (!_excludedParams) {
    _excludedParams = [NSMutableArray array];
  }
  return _excludedParams;
}

- (void)setCode:(NSString *)code
{
  _code = code;
  _codes = nil;
}

- (void)setCodes:(NSArray *)codes
{
  _codes = codes;
  _code = nil;
}

- (id)copyWithZone:(NSZone *)zone
{
  DSMessageInterceptor *copy = [[[self class] allocWithZone:zone] init];
  if (copy) {
    if (self.code) {
      [copy setCode:self.code];
    }
    
    if (self.codes) {
      [copy setCodes:self.codes];
    }
    
    [copy setHandler:self.handler];
    
    [copy setDomain:self.domain];
    
    [copy setExcludedParams:self.excludedParams];
    
    copy.shouldAllowOthersToProceed = self.shouldAllowOthersToProceed;
    copy.isActive = self.isActive;
  }
  
  return copy;
}

- (void)excludeParamsFromInterception:(Class)params
{
  NSParameterAssert([params isSubclassOfClass:[DSWebServiceParams class]]);
  
  [self.excludedParams addObject:[params class]];
}

- (BOOL)shouldInterceptParams:(DSWebServiceParams *)params
{
  return ![self.excludedParams containsObject:[params class]];
}

@end
