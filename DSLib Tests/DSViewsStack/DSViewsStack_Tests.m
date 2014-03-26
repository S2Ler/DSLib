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
{
  NSUInteger _viewsReturnedCount;
  NSUInteger _viewsCount;
  NSUInteger _viewsCreatedCount;
}

- (void)setUp
{
  [super setUp];
  [self setViewsStack:[[DSViewsStack alloc] init]];
  [[self viewsStack] setDelegate:self];
  [[self viewsStack] setDataSource:self];
  _viewsReturnedCount = 0;
  _viewsCount = 10;
  _viewsCreatedCount = 0;
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
  [[self viewsStack] setDelegate:nil];
  
  XCTAssertNoThrow([[self viewsStack] setDelegate:self], @"Set delegate not implemented");
  XCTAssertEqualObjects([[self viewsStack] delegate], self, @"Set delegate doesn't work correctly");
}

- (void)testDataSourceCanBeSet
{
  [[self viewsStack] setDelegate:nil];
  XCTAssertNoThrow([[self viewsStack] setDataSource:self], @"Set dataSource not implemented");
  XCTAssertEqualObjects([[self viewsStack] dataSource], self, @"Set dataSource doesn't work correctly");
}

- (void)testNumberOfViews
{
  XCTAssertEqual([[self viewsStack] numberOfViews], [self numberOfViewsInViewsStack:nil], @"Number of views doesn't work");
}

- (void)testViewForIndex
{
  for (NSUInteger index = 0; index < [self numberOfViewsInViewsStack:nil]; index++) {
    XCTAssertNoThrow([[self viewsStack] viewForIndex:index], @"viewForIndex doesn't handle all indexes correctly");
  }
  
  for (NSUInteger index = 0; index < [self numberOfViewsInViewsStack:nil]; index++) {
    XCTAssertNotNil([[self viewsStack] viewForIndex:index], @"Returning empty view for correct index");
  }
}

- (void)testReloadData
{
  [[self viewsStack] reloadData];
  XCTAssert(_viewsReturnedCount > 0, @"Views are not reloaded after reloadData is called");
}

- (void)testThatOnlyTwoViewsLoadedAtAnyGivenTime
{
  [[self viewsStack] reloadData];
  XCTAssertEqual(_viewsReturnedCount, 2, @"Only two views should be visible at any given time");
}

- (void)testEmptyViews
{
  _viewsCount = 0;
  XCTAssertNoThrow([[self viewsStack] reloadData], @"Exception if empty stack");
  XCTAssertEqual(_viewsReturnedCount, 0, @"On empty stack no views should be asked");
}

- (void)testNextViewAnimated
{
  _viewsCount = 5;
  [[self viewsStack] reloadData];
  BOOL showedNextView = [[self viewsStack] showNextViewAnimated:NO];
  XCTAssertEqual(_viewsReturnedCount, 3, @"Should load next view, but didn't");
  XCTAssertEqual(showedNextView, YES, @"There are more than 3 views in datasource. Should be able to show next view");
}

- (void)testNextViewAnimatedWhenThereIsNoMoreViews
{
  _viewsCount = 2;
  [[self viewsStack] reloadData];
  BOOL showedNextView = [[self viewsStack] showNextViewAnimated:NO];
  XCTAssertEqual(_viewsReturnedCount, 2, @"Shouldn't load next view as it already loaded");
  XCTAssertEqual(showedNextView, YES, @"We showing first view now. Should be able to show next view");
  showedNextView = [[self viewsStack] showNextViewAnimated:NO];
  XCTAssertEqual(showedNextView, NO, @"We showing second view now. Should be able to show next view");
}

- (void)testDequeueReusableView
{
  [[self viewsStack] reloadData];
  [[self viewsStack] showNextViewAnimated:NO];
  UIView *reusableView = [[self viewsStack] dequeueReusableView];
  XCTAssertNil(reusableView, @"Reusable view API doesn't work correctly");
  XCTAssert(_viewsCreatedCount == 2, @"Only two views should be created at any given time");
}

#pragma mark - DSViewsStackDataSource, DSViewsStackDelegate
- (NSUInteger)numberOfViewsInViewsStack:(DSViewsStack *)viewsStack
{
  return _viewsCount;
}

- (UIView *)viewsStack:(DSViewsStack *)viewsStack viewForIndex:(NSUInteger)viewIndex
{
  _viewsReturnedCount++;
  
  UIView *view = [viewsStack dequeueReusableView];
  
  if (view) {
    return view;
  }
  else {
    _viewsCreatedCount = 2;
    return [[UIView alloc] init];
  }
}

@end
