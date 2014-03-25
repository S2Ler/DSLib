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
#import "DSViewsStackDelegate.h"
#import "DSViewsStackDataSource.h"

@interface DSViewsStack_Tests : XCTestCase<DSViewsStackDelegate, DSViewsStackDataSource>
@property (nonatomic, strong) DSViewsStack *viewsStack;
@end

@implementation DSViewsStack_Tests

- (void)setUp
{
  [super setUp];
  [self setViewsStack:[[DSViewsStack alloc] init]];
  [[self viewsStack] setDelegate:self];
  [[self viewsStack] setDataSource:self];
}

- (void)tearDown
{
  // Put teardown code here. This method is called after the invocation of each test method in the class.
  [super tearDown];
}

- (void)testCreationPossible
{
  XCTAssertNotNil([self viewsStack], @"Can't create views stack");
}

- (void)testDelegateCanBeSet
{
  XCTAssertNoThrow([[self viewsStack] setDelegate:self], @"Set delegate not implemented");
  XCTAssertEqualObjects([[self viewsStack] delegate], self, @"Set delegate doesn't work correctly");
}

- (void)testDataSourceCanBeSet
{
  XCTAssertNoThrow([[self viewsStack] setDataSource:self], @"Set dataSource not implemented");
  XCTAssertEqualObjects([[self viewsStack] dataSource], self, @"Set dataSource doesn't work correctly");
}

- (void)testNumberOfViews
{
  [[self viewsStack] setDataSource:self];
  XCTAssertEqual([[self viewsStack] numberOfViews], [self numberOfViewsInViewsStack:nil], @"Number of views doesn't work");
}

- (void)testViewForIndex
{
  [[self viewsStack] setDataSource:self];
  for (NSUInteger index = 0; index < [self numberOfViewsInViewsStack:nil]; index++) {
    XCTAssertNoThrow([[self viewsStack] viewForIndex:index], @"viewForIndex doesn't handle all indexes correctly");
  }
  
  for (NSUInteger index = 0; index < [self numberOfViewsInViewsStack:nil]; index++) {
    XCTAssertNotNil([[self viewsStack] viewForIndex:index], @"Returning empty view for correct index");
  }
}

- (void)testThatOnlyTwoViewsLoadedAtAnyGivenTime
{
  
}

#pragma mark - DSViewsStackDataSource, DSViewsStackDelegate
- (NSUInteger)numberOfViewsInViewsStack:(DSViewsStack *)viewsStack
{
  return 11;
}

- (UIView *)viewsStack:(DSViewsStack *)viewsStack viewForIndex:(NSUInteger)viewIndex
{
  return [[UIView alloc] init];
}

@end
