//
//  ALAsset+DSAdditions.m
//  DSLib
//
//  Created by Alexander Belyavskiy on 3/12/14.
//  Copyright (c) 2014 DS ltd. All rights reserved.
//

#import "ALAsset+DSAdditions.h"
#import "DSCFunctions.h"
#import "NSOutputStream+DSAdditions.h"

@implementation ALAsset (DSAdditions)
- (BOOL)copyToPath:(NSString *)path error:(NSError *__autoreleasing*)error
{
  ALAssetRepresentation *representation = [self defaultRepresentation];
  
  BOOL createSucceeded = [[NSFileManager defaultManager] createFileAtPath:path contents:nil attributes:nil];
  if (!createSucceeded) {
    *error = [NSError errorWithDomain:NSURLErrorDomain code:NSURLErrorBadURL userInfo:nil];
    return NO;
  }
  
  NSOutputStream *outputStream = [NSOutputStream outputStreamToFileAtPath:path append:NO];
  [outputStream open];
  
  DSFileSize offset = 0;
  DSFileSize readChunkSize = 0;
  
  uint8_t * buffer = malloc(COPY_BUFFER_SIZE);
  
  NSError *writeError = nil;
  while (!writeError && offset < [representation size] && [outputStream hasSpaceAvailable]) {
    readChunkSize = [representation getBytes:buffer fromOffset:offset length:COPY_BUFFER_SIZE error:&writeError];
    
    if (!writeError) {
      [outputStream writeData:[NSData dataWithBytesNoCopy:buffer
                                                   length:(NSUInteger)readChunkSize
                                             freeWhenDone:NO] error:&writeError];
      offset = offset + readChunkSize;
    }
    else {
      break;
    }
  }

  [outputStream close];
  free(buffer);
  
  if (writeError) {
    *error = writeError;
    [[NSFileManager defaultManager] removeItemAtPath:path error:nil];
    return NO;
  }
  else {
    return YES;
  }
}
@end
