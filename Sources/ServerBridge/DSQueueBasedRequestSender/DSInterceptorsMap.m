//
//  DSInterceptorsMap.m
//  DSLib
//
//  Created by Alexander Belyavskiy on 4/2/15.
//  Copyright (c) 2015 DS ltd. All rights reserved.
//

#pragma mark - include
#import "DSInterceptorsMap.h"
#import "DSMessage.h"
#import "DSMessageInterceptor.h"

@interface DSInterceptorsMap ()
@property (nonatomic, strong) NSMapTable *interceptorsMap;
@end


@implementation DSInterceptorsMap

- (instancetype)init
{
  self = [super init];
  if (self) {
      _interceptorsMap = [[NSMapTable alloc] initWithKeyOptions:NSPointerFunctionsStrongMemory
                                                   valueOptions:NSPointerFunctionsStrongMemory
                                                       capacity:2];
  }
  return self;
}

- (NSMutableArray *)_interceptorsForMessage:(DSMessage *)message
{
  NSMutableArray *interceptors = [self.interceptorsMap objectForKey:message];
  if (!interceptors) {
    interceptors = [[NSMutableArray alloc] initWithCapacity:2];
  }
  [self.interceptorsMap setObject:interceptors forKey:message];
  return interceptors;
}

- (NSArray *)interceptorsForMessage:(DSMessage *)message
{
  return [[self _interceptorsForMessage:message] copy];
}

- (NSArray *)messagesForInterceptor:(DSMessageInterceptor *)interceptor
{
  NSMutableArray *messages = [NSMutableArray array];
  
  if ([interceptor code]) {
    DSMessage *message = [DSMessage messageWithDomain:[interceptor domain] code:[interceptor code]];
    [messages addObject:message];
  }
  else {
    for (DSMessageCode *code in [interceptor codes]) {
      DSMessage *message = [DSMessage messageWithDomain:[interceptor domain] code:code];
      [messages addObject:message];
    }
  }
  
  return messages;
}

- (void)addInterceptor:(DSMessageInterceptor *)interceptor
{
  NSArray *messages = [self messagesForInterceptor:interceptor];
  for (DSMessage *message in messages) {
    NSMutableArray *interceptorsForMessage = [self _interceptorsForMessage:message];
    [interceptorsForMessage addObject:interceptor];
  }
}

- (void)removeInterceptor:(DSMessageInterceptor *)interceptor
{
  NSArray *messages = [self messagesForInterceptor:interceptor];
  
  for (DSMessage *message in messages) {
    NSMutableArray *interceptorsForMessage = [self _interceptorsForMessage:message];
    [interceptorsForMessage removeObject:interceptor];
  }
}

@end
