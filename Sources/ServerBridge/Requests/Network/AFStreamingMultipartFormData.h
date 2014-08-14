//
//  AFStreamingMultipartFormData.h
//  DSLib
//
//  Created by Alexander Belyavskiy on 3/4/14.
//  Copyright (c) 2014 DS ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFMultipartFormData.h"

@interface AFStreamingMultipartFormData : NSObject <AFMultipartFormData>
- (instancetype)initWithURLRequest:(NSMutableURLRequest *)urlRequest
                    stringEncoding:(NSStringEncoding)encoding;
- (NSMutableURLRequest *)requestByFinalizingMultipartFormData;

- (instancetype)initWithStringEncoding:(NSStringEncoding)encoding;
- (NSInputStream *)createInputStream;
@end