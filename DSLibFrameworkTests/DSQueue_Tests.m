//
//  DSQueue_Tests.m
//  DSLib
//
//  Created by Alexander Belyavskiy on 3/28/15.
//  Copyright (c) 2015 DS ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
@import DSLibFramework;
@import Expecta;

@interface DSQueue_Tests : XCTestCase
@property (nonatomic, strong) DSQueue *queue;
@end

@implementation DSQueue_Tests

- (void)setUp {
  [super setUp];
  self.queue = [[DSQueue alloc] init];
}

- (void)tearDown {
  [super tearDown];
  self.queue = nil;
}

- (void)testAddPerformance
{
  [self measureBlock:^{
    for (NSInteger i = 0; i < 10000; i++) {
      [self.queue push:@(i)];
    }
  }];
}

- (void)testPopPerformance
{
  for (NSInteger i = 0; i < 10000; i++) {
    [self.queue push:@(i)];
  }

  [self measureBlock:^{
    for (NSInteger i = 0; i < 10000; i++) {
      [self.queue pop];
    }
  }];
}



@end
