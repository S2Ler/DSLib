//
//  NSOutputStream+DSAdditions.m
//  DSLib
//
//  Created by Alexander Belyavskiy on 3/12/14.
//  Copyright (c) 2014 DS ltd. All rights reserved.
//

#import "NSOutputStream+DSAdditions.h"

@implementation NSOutputStream (DSAdditions)
- (NSInteger)writeData:(NSData *)data error:(NSError *__autoreleasing*)error {
  NSUInteger length = [data length];
  while (YES) {
    NSInteger totalNumberOfBytesWritten = 0;
    if ([self hasSpaceAvailable]) {
      const uint8_t *dataBuffer = (uint8_t *)[data bytes];
      
      NSInteger numberOfBytesWritten = 0;
      while (totalNumberOfBytesWritten < (NSInteger)length) {
        numberOfBytesWritten = [self write:&dataBuffer[(NSUInteger)totalNumberOfBytesWritten]
                                 maxLength:(length - (NSUInteger)totalNumberOfBytesWritten)];
        if (numberOfBytesWritten == -1) {
          break;
        }
        
        totalNumberOfBytesWritten += numberOfBytesWritten;
      }
      
      break;
    }
    
    if ([self streamError]) {
      if (error) {
        *error = [self streamError];
      }
      return totalNumberOfBytesWritten;
    }
  }
  
  return length;
}
@end
