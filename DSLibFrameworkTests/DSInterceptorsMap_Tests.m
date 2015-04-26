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
#import "DSMessageInterceptor.h"
#import "NSError+DSWebService.h"
#import "DSMessage.h"


@interface DSInterceptorsMap_Tests : XCTestCase
@property (nonatomic, strong) DSInterceptorsMap *interceptorsMap;
@end

@implementation DSInterceptorsMap_Tests

- (void)setUp {
  [super setUp];
  self.interceptorsMap = [DSInterceptorsMap new];
}

- (void)tearDown {
    [super tearDown];
  self.interceptorsMap = nil;
}

- (void)testCanAddInterceptorAndTheRetriveIt_single_code
{
  DSMessageInterceptor *interceptor = [DSMessageInterceptor new];
  interceptor.domain = kDSMessageDomainWebService;
  interceptor.code = @"err";
  [self.interceptorsMap addInterceptor:interceptor];
  
  DSMessage *message = [DSMessage messageWithDomain:kDSMessageDomainWebService
                                               code:@"err"];
  
  NSArray *interceptors = [self.interceptorsMap interceptorsForMessage:message];
  XCTAssert([interceptors count] == 1, @"");
  XCTAssert([interceptors objectAtIndex:0] == interceptor, @"");  
}

- (void)testCanAddInterceptorAndTheRetriveIt_mult_code
{
  DSMessageInterceptor *interceptor = [DSMessageInterceptor new];
  interceptor.domain = kDSMessageDomainWebService;
  interceptor.codes = @[@"err", @"err2"];
  [self.interceptorsMap addInterceptor:interceptor];
  
  DSMessage *message1 = [DSMessage messageWithDomain:kDSMessageDomainWebService
                                               code:@"err"];
  DSMessage *message2 = [DSMessage messageWithDomain:kDSMessageDomainWebService
                                                code:@"err2"];
  
  NSArray *interceptors = [self.interceptorsMap interceptorsForMessage:message1];
  XCTAssert([interceptors count] == 1, @"");
  XCTAssert([interceptors containsObject:interceptor] == true, @"");
  interceptors = [self.interceptorsMap interceptorsForMessage:message2];
  XCTAssert([interceptors count] == 1, @"");
  XCTAssert([interceptors containsObject:interceptor] == true, @"");
  
  interceptors = [self.interceptorsMap interceptorsForMessage:[DSMessage messageWithDomain:kDSMessageDomainWebService code:@"err3"]];
  XCTAssert([interceptors count] == 0, @"");
  
  [self.interceptorsMap removeInterceptor:interceptor];
  
  interceptors = [self.interceptorsMap interceptorsForMessage:message1];
  XCTAssert([interceptors count] == 0, @"");
  interceptors = [self.interceptorsMap interceptorsForMessage:message2];
  XCTAssert([interceptors count] == 0, @"");
}
@end
