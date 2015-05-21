//
//  NSDataHexString.m
//  DSLib
//
//  Created by Alexander Belyavskiy on 5/21/15.
//  Copyright (c) 2015 DS ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "NSData+OAdditions.h"

@interface NSDataHexString : XCTestCase

@end

@implementation NSDataHexString

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

NSString *letters = @"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";

-(NSString *) randomStringWithLength: (int) len {
  
  NSMutableString *randomString = [NSMutableString stringWithCapacity: len];
  
  for (int i=0; i<len; i++) {
    [randomString appendFormat: @"%C", [letters characterAtIndex: arc4random_uniform([letters length])]];
  }
  
  return randomString;
}

- (void)testExample {
  for (int i = 0; i <= 100; i++) {
    for (int i = 0; i <= 100; i++) {
      NSString *s = [self randomStringWithLength:i];
      NSData *d = [s dataUsingEncoding:NSUTF8StringEncoding];
      NSString *s2 = [d hexString];
      XCTAssert([s2 rangeOfString:@" "].location == NSNotFound, @"Space found. Wrong");
    }
  }
}

- (void)testPerformanceExample {

}

@end
