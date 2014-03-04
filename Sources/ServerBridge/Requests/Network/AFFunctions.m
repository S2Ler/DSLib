//
//  AFFunctions.m
//  DSLib
//
//  Created by Alexander Belyavskiy on 3/4/14.
//  Copyright (c) 2014 DS ltd. All rights reserved.
//

#import "AFFunctions.h"

NSString * const kAFMultipartFormCRLF = @"\r\n";
NSString * const AFNetworkingErrorDomain = @"AFNetworkingErrorDomain";

NSString * AFCreateMultipartFormBoundary(void) {
  return [NSString stringWithFormat:@"Boundary+%08X%08X", arc4random(), arc4random()];
}

NSString * AFMultipartFormInitialBoundary(NSString *boundary) {
  return [NSString stringWithFormat:@"--%@%@", boundary, kAFMultipartFormCRLF];
}

NSString * AFMultipartFormEncapsulationBoundary(NSString *boundary) {
  return [NSString stringWithFormat:@"%@--%@%@", kAFMultipartFormCRLF, boundary, kAFMultipartFormCRLF];
}

NSString * AFMultipartFormFinalBoundary(NSString *boundary) {
  return [NSString stringWithFormat:@"%@--%@--%@", kAFMultipartFormCRLF, boundary, kAFMultipartFormCRLF];
}

NSString * AFContentTypeForPathExtension(NSString *extension) {
#ifdef __UTTYPE__
  NSString *UTI = (__bridge_transfer NSString *)UTTypeCreatePreferredIdentifierForTag(kUTTagClassFilenameExtension, (__bridge CFStringRef)extension, NULL);
  NSString *contentType = (__bridge_transfer NSString *)UTTypeCopyPreferredTagWithClass((__bridge CFStringRef)UTI, kUTTagClassMIMEType);
  if (!contentType) {
    return @"application/octet-stream";
  } else {
    return contentType;
  }
#else
#pragma unused (extension)
  return @"application/octet-stream";
#endif
}