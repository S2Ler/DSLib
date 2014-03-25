//
//  DSViewsStack_Tests.m
//  DSLib
//
//  Created by Alexander Belyavskiy on 3/25/14.
//  Copyright (c) 2014 DS ltd. All rights reserved.
//

#pragma mark - include
#import <XCTest/XCTest.h>
#import "DSViewsStack.h"

@interface DSViewsStack_Tests : XCTestCase

@end

@implementation DSViewsStack_Tests

- (void)setUp
{
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testCreationPossible
{
  DSViewsStack *viewsStack = [[DSViewsStack alloc] init];
  XCTAssertNotNil(viewsStack, @"Can't create views stack");
}

@end
