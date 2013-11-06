//
//  DSAlertsQueue.m
//  DSLib
//
//  Created by Alex on 23/10/2013.
//  Copyright (c) 2013 DS ltd. All rights reserved.
//

#pragma mark - include
#import "DSAlertsQueue.h"
#import "DSQueue.h"
#import "DSAlertsHandler.h"
#import "DSMessage.h"
#import "DSAlertsHandler+SimplifiedAPI.h"
#import "DSAlert.h"
#import "DSTimeFunctions.h"

@interface DSAlertsQueue ()
@property (nonatomic, strong) DSQueue *queue;
@property (nonatomic, strong) NSTimer *despatchTimer;

@end

@implementation DSAlertsQueue

- (id)init
{
  self = [super init];
  if (self) {
    _queue = [[DSQueue alloc] init];
    [self setDespatchInterval:NSTimeIntervalWithSeconds(2)];
  }
  return self;
}

- (void)setDespatchInterval:(NSTimeInterval)despatchInterval
{
  [[self despatchTimer] invalidate];
  [self setDespatchTimer:[NSTimer scheduledTimerWithTimeInterval:despatchInterval
                                                          target:self
                                                        selector:@selector(commit)
                                                        userInfo:nil
                                                         repeats:YES]];
}

- (NSTimeInterval)despatchInterval
{
  return [[self despatchTimer] timeInterval];
}

- (void)addMessage:(DSMessage *)message
{
  [_queue push:message];
}

- (void)addAlert:(DSAlert *)alert modal:(BOOL)isModal
{
  NSDictionary *definition = @{@"object": alert, @"modal":@(isModal)};
  [_queue push:definition];
}

- (void)addError:(NSError *)error
{
  NSDictionary *definition = @{@"object": error, @"isParse": @(NO)};
  [_queue push:definition];
}

- (void)addParseError:(NSError *)error
{
  NSDictionary *definition = @{@"object": error, @"isParse": @(YES)};
  [_queue push:definition];
}

- (void)commit
{
  for (id anAlertsObject in [self queue]) {
    if ([anAlertsObject isKindOfClass:[DSMessage class]]) {
      DSMessage *message = anAlertsObject;
      [_alertsHandler showSimpleMessageAlert:message];
    }
    else if ([anAlertsObject isKindOfClass:[NSDictionary class]]) {
      NSDictionary *definition = anAlertsObject;
      id object = definition[@"object"];
      if ([object isKindOfClass:[DSAlert class]]) {
        NSNumber *modalNumber = definition[@"modal"];
        [_alertsHandler showAlert:object modally:(modalNumber ? [modalNumber boolValue] : YES)];
      }
      else if ([object isKindOfClass:[NSError class]]) {
        NSNumber *isParseError = definition[@"isParse"];
        NSError *error = object;
        if (isParseError?[isParseError boolValue]:NO) {
          [_alertsHandler showParseError:error];
        }
        else {
          [_alertsHandler showError:error];
        }
      }
    }
  }
  
  [[self queue] removeAll];
}
@end
