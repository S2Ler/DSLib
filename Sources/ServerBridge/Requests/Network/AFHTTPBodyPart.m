//
//  AFHTTPBodyPart.m
//  DSLib
//
//  Created by Alexander Belyavskiy on 3/4/14.
//  Copyright (c) 2014 DS ltd. All rights reserved.
//

#import "AFHTTPBodyPart.h"
#import "AFHTTPBodyPartReadPhase.h"
#import "AFFunctions.h"

@interface AFHTTPBodyPart () <NSCopying> {
  AFHTTPBodyPartReadPhase _phase;
  NSInputStream *_inputStream;
  NSUInteger _phaseReadOffset;
}

- (BOOL)transitionToNextPhase;
- (NSInteger)readData:(NSData *)data
           intoBuffer:(uint8_t *)buffer
            maxLength:(NSUInteger)length;
@end

@implementation AFHTTPBodyPart

- (id)init {
  self = [super init];
  if (!self) {
    return nil;
  }
  
  [self transitionToNextPhase];
  
  return self;
}

- (void)dealloc {
  if (_inputStream) {
    [_inputStream close];
    _inputStream = nil;
  }
}

- (NSInputStream *)inputStream {
  if (!_inputStream) {
    if ([self.body isKindOfClass:[NSData class]]) {
      _inputStream = [NSInputStream inputStreamWithData:self.body];
    } else if ([self.body isKindOfClass:[NSURL class]]) {
      _inputStream = [NSInputStream inputStreamWithURL:self.body];
    } else if ([self.body isKindOfClass:[NSInputStream class]]) {
      _inputStream = self.body;
    }
  }
  
  return _inputStream;
}

- (NSString *)stringForHeaders {
  NSMutableString *headerString = [NSMutableString string];
  for (NSString *field in [self.headers allKeys]) {
    [headerString appendString:[NSString stringWithFormat:@"%@: %@%@", field, [self.headers valueForKey:field], kAFMultipartFormCRLF]];
  }
  [headerString appendString:kAFMultipartFormCRLF];
  
  return [NSString stringWithString:headerString];
}

- (NSUInteger)contentLength {
  NSUInteger length = 0;
  
  NSData *encapsulationBoundaryData = [([self hasInitialBoundary] ? AFMultipartFormInitialBoundary(self.boundary) : AFMultipartFormEncapsulationBoundary(self.boundary)) dataUsingEncoding:self.stringEncoding];
  length += [encapsulationBoundaryData length];
  
  NSData *headersData = [[self stringForHeaders] dataUsingEncoding:self.stringEncoding];
  length += [headersData length];
  
  length += _bodyContentLength;
  
  NSData *closingBoundaryData = ([self hasFinalBoundary] ? [AFMultipartFormFinalBoundary(self.boundary) dataUsingEncoding:self.stringEncoding] : [NSData data]);
  length += [closingBoundaryData length];
  
  return length;
}

- (BOOL)hasBytesAvailable {
  // Allows `read:maxLength:` to be called again if `AFMultipartFormFinalBoundary` doesn't fit into the available buffer
  if (_phase == AFFinalBoundaryPhase) {
    return YES;
  }
  
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wcovered-switch-default"
  switch (self.inputStream.streamStatus) {
    case NSStreamStatusNotOpen:
    case NSStreamStatusOpening:
    case NSStreamStatusOpen:
    case NSStreamStatusReading:
    case NSStreamStatusWriting:
      return YES;
    case NSStreamStatusAtEnd:
    case NSStreamStatusClosed:
    case NSStreamStatusError:
    default:
      return NO;
  }
#pragma clang diagnostic pop
}

- (NSInteger)read:(uint8_t *)buffer
        maxLength:(NSUInteger)length
{
  NSInteger totalNumberOfBytesRead = 0;
  
  if (_phase == AFEncapsulationBoundaryPhase) {
    NSData *encapsulationBoundaryData = [([self hasInitialBoundary] ? AFMultipartFormInitialBoundary(self.boundary) : AFMultipartFormEncapsulationBoundary(self.boundary)) dataUsingEncoding:self.stringEncoding];
    totalNumberOfBytesRead += [self readData:encapsulationBoundaryData intoBuffer:&buffer[totalNumberOfBytesRead] maxLength:(length - (NSUInteger)totalNumberOfBytesRead)];
  }
  
  if (_phase == AFHeaderPhase) {
    NSData *headersData = [[self stringForHeaders] dataUsingEncoding:self.stringEncoding];
    totalNumberOfBytesRead += [self readData:headersData intoBuffer:&buffer[totalNumberOfBytesRead] maxLength:(length - (NSUInteger)totalNumberOfBytesRead)];
  }
  
  if (_phase == AFBodyPhase) {
    NSInteger numberOfBytesRead = 0;
    
    numberOfBytesRead = [self.inputStream read:&buffer[totalNumberOfBytesRead] maxLength:(length - (NSUInteger)totalNumberOfBytesRead)];
    if (numberOfBytesRead == -1) {
      return -1;
    } else {
      totalNumberOfBytesRead += numberOfBytesRead;
      
      if ([self.inputStream streamStatus] >= NSStreamStatusAtEnd) {
        [self transitionToNextPhase];
      }
    }
  }
  
  if (_phase == AFFinalBoundaryPhase) {
    NSData *closingBoundaryData = ([self hasFinalBoundary] ? [AFMultipartFormFinalBoundary(self.boundary) dataUsingEncoding:self.stringEncoding] : [NSData data]);
    totalNumberOfBytesRead += [self readData:closingBoundaryData intoBuffer:&buffer[totalNumberOfBytesRead] maxLength:(length - (NSUInteger)totalNumberOfBytesRead)];
  }
  
  return totalNumberOfBytesRead;
}

- (NSInteger)readData:(NSData *)data
           intoBuffer:(uint8_t *)buffer
            maxLength:(NSUInteger)length
{
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wgnu"
  NSRange range = NSMakeRange(_phaseReadOffset, MIN([data length] - _phaseReadOffset, length));
  [data getBytes:buffer range:range];
#pragma clang diagnostic pop
  
  _phaseReadOffset += range.length;
  
  if (_phaseReadOffset >= [data length]) {
    [self transitionToNextPhase];
  }
  
  return (NSInteger)range.length;
}

- (BOOL)transitionToNextPhase {
  if (![[NSThread currentThread] isMainThread]) {
    [self performSelectorOnMainThread:@selector(transitionToNextPhase) withObject:nil waitUntilDone:YES];
    return YES;
  }
  
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wcovered-switch-default"
  switch (_phase) {
    case AFEncapsulationBoundaryPhase:
      _phase = AFHeaderPhase;
      break;
    case AFHeaderPhase:
      [self.inputStream scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
      [self.inputStream open];
      _phase = AFBodyPhase;
      break;
    case AFBodyPhase:
      [self.inputStream close];
      _phase = AFFinalBoundaryPhase;
      break;
    case AFFinalBoundaryPhase:
    default:
      _phase = AFEncapsulationBoundaryPhase;
      break;
  }
  _phaseReadOffset = 0;
#pragma clang diagnostic pop
  
  return YES;
}

#pragma mark - NSCopying

- (id)copyWithZone:(NSZone *)zone {
  AFHTTPBodyPart *bodyPart = [[[self class] allocWithZone:zone] init];
  
  bodyPart.stringEncoding = self.stringEncoding;
  bodyPart.headers = self.headers;
  bodyPart.bodyContentLength = self.bodyContentLength;
  bodyPart.body = self.body;
  
  return bodyPart;
}

@end