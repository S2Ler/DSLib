//
//  DSInterceptorsMap_Tests.m
//  DSLib
//
//  Created by Alexander Belyavskiy on 4/2/15.
//  Copyright (c) 2015 DS ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "DSInterceptorsMap.h"

@interface DSInterceptorsMap_Tests : XCTestCase
@property (nonatomic, strong) DSInterceptorsMap *interceptorsMap;
@end

@implementation DSInterceptorsMap_Tests

- (void)setUp {
    [super setUp];
  
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample {
    // This is an example of a functional test case.
    XCTAssert(YES, @"Pass");
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
