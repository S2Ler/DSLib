//
//  AFMultipartBodyStream.h
//  DSLib
//
//  Created by Alexander Belyavskiy on 3/4/14.
//  Copyright (c) 2014 DS ltd. All rights reserved.
//

@import Foundation;

@class AFHTTPBodyPart;

@interface AFMultipartBodyStream : NSInputStream <NSStreamDelegate>
@property (nonatomic, assign) NSUInteger numberOfBytesInPacket;
@property (nonatomic, assign) NSTimeInterval delay;
@property (nonatomic, strong) NSInputStream *inputStream;
@property (nonatomic, readonly, assign) NSUInteger contentLength;
@property (nonatomic, readonly, assign, getter = isEmpty) BOOL empty;

- (id)initWithStringEncoding:(NSStringEncoding)encoding;
- (void)setInitialAndFinalBoundaries;
- (void)appendHTTPBodyPart:(AFHTTPBodyPart *)bodyPart;
@end