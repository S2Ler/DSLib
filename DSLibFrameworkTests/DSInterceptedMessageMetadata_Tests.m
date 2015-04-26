//
//  DSInterceptedMessageMetadata_TEsts.m
//  DSLib
//
//  Created by Alexander Belyavskiy on 4/17/15.
//  Copyright (c) 2015 DS ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "DSInterceptedMessageMetadata.h"
#import "DSWebServiceParams.h"

@interface Params1 : DSWebServiceParams

@end

@interface Params2 : DSWebServiceParams

@end

@interface DSInterceptedMessageMetadata_Tests : XCTestCase

@end

@implementation DSInterceptedMessageMetadata_Tests

- (void)setUp {
    [super setUp];
}

- (void)tearDown {
    [super tearDown];
}

- (void)testAnyOfParams {
  DSInterceptedMessageMetadata *metadata = [DSInterceptedMessageMetadata new];
  metadata.params = [Params1 new];
  
  NSArray *testParams;
  
  testParams = @[[Params2 class], [Params1 class]];
  XCTAssertTrue([metadata anyOfParams:testParams]);
  
  testParams = @[[Params2 class]];
  XCTAssertFalse([metadata anyOfParams:testParams]);
  
  testParams = @[[Params1 class]];
  XCTAssertTrue([metadata anyOfParams:testParams]);
  
  XCTAssertFalse([metadata anyOfParams:nil]);
  XCTAssertFalse([metadata anyOfParams:@[]]);
  XCTAssertFalse([metadata anyOfParams:@[[self class]]]);
}

@end
                     
@implementation Params1

@end

@implementation Params2

@end
