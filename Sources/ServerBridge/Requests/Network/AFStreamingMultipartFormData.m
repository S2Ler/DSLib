//
//  AFStreamingMultipartFormData.m
//  DSLib
//
//  Created by Alexander Belyavskiy on 3/4/14.
//  Copyright (c) 2014 DS ltd. All rights reserved.
//

#import "AFStreamingMultipartFormData.h"
#import "AFMultipartBodyStream.h"
#import "AFFunctions.h"
#import "AFHTTPBodyPart.h"

@interface AFStreamingMultipartFormData ()
@property (readwrite, nonatomic, copy) NSMutableURLRequest *request;
@property (readwrite, nonatomic, assign) NSStringEncoding stringEncoding;
@property (readwrite, nonatomic, copy) NSString *boundary;
@property (readwrite, nonatomic, strong) AFMultipartBodyStream *bodyStream;
@end

@implementation AFStreamingMultipartFormData

- (id)initWithURLRequest:(NSMutableURLRequest *)urlRequest
          stringEncoding:(NSStringEncoding)encoding
{
  self = [super init];
  
  if (self) {
    self.request = urlRequest;
    self.stringEncoding = encoding;
    self.boundary = AFCreateMultipartFormBoundary();
    self.bodyStream = [[AFMultipartBodyStream alloc] initWithStringEncoding:encoding];
  }
  
  return self;
}

- (instancetype)initWithStringEncoding:(NSStringEncoding)encoding
{
  self = [super init];
  if (self) {
    self.stringEncoding = encoding;
    self.boundary = AFCreateMultipartFormBoundary();
    self.bodyStream = [[AFMultipartBodyStream alloc] initWithStringEncoding:encoding];
  }
  return self;
}

- (BOOL)appendPartWithFileURL:(NSURL *)fileURL
                         name:(NSString *)name
                        error:(NSError * __autoreleasing *)error
{
  NSParameterAssert(fileURL);
  NSParameterAssert(name);
  
  NSString *fileName = [fileURL lastPathComponent];
  NSString *mimeType = AFContentTypeForPathExtension([fileURL pathExtension]);
  
  return [self appendPartWithFileURL:fileURL name:name fileName:fileName mimeType:mimeType error:error];
}

- (BOOL)appendPartWithFileURL:(NSURL *)fileURL
                         name:(NSString *)name
                     fileName:(NSString *)fileName
                     mimeType:(NSString *)mimeType
                        error:(NSError * __autoreleasing *)error
{
  NSParameterAssert(fileURL);
  NSParameterAssert(name);
  NSParameterAssert(fileName);
  NSParameterAssert(mimeType);
  
  if (![fileURL isFileURL]) {
    NSDictionary *userInfo = [NSDictionary dictionaryWithObject:NSLocalizedStringFromTable(@"Expected URL to be a file URL", @"AFNetworking", nil) forKey:NSLocalizedFailureReasonErrorKey];
    if (error) {
      *error = [[NSError alloc] initWithDomain:AFNetworkingErrorDomain code:NSURLErrorBadURL userInfo:userInfo];
    }
    
    return NO;
  } else if ([fileURL checkResourceIsReachableAndReturnError:error] == NO) {
    NSDictionary *userInfo = [NSDictionary dictionaryWithObject:NSLocalizedStringFromTable(@"File URL not reachable.", @"AFNetworking", nil) forKey:NSLocalizedFailureReasonErrorKey];
    if (error) {
      *error = [[NSError alloc] initWithDomain:AFNetworkingErrorDomain code:NSURLErrorBadURL userInfo:userInfo];
    }
    
    return NO;
  }
  
  NSDictionary *fileAttributes = [[NSFileManager defaultManager] attributesOfItemAtPath:[fileURL path] error:error];
  if (!fileAttributes) {
    return NO;
  }
  
  NSMutableDictionary *mutableHeaders = [NSMutableDictionary dictionary];
  [mutableHeaders setValue:[NSString stringWithFormat:@"form-data; name=\"%@\"; filename=\"%@\"", name, fileName] forKey:@"Content-Disposition"];
  [mutableHeaders setValue:mimeType forKey:@"Content-Type"];
  
  AFHTTPBodyPart *bodyPart = [[AFHTTPBodyPart alloc] init];
  bodyPart.stringEncoding = self.stringEncoding;
  bodyPart.headers = mutableHeaders;
  bodyPart.boundary = self.boundary;
  bodyPart.body = fileURL;
  bodyPart.bodyContentLength = [[fileAttributes objectForKey:NSFileSize] unsignedIntegerValue];
  [self.bodyStream appendHTTPBodyPart:bodyPart];
  
  return YES;
}

- (void)appendPartWithInputStream:(NSInputStream *)inputStream
                             name:(NSString *)name
                         fileName:(NSString *)fileName
                           length:(NSUInteger)length
                         mimeType:(NSString *)mimeType
{
  NSParameterAssert(name);
  NSParameterAssert(fileName);
  NSParameterAssert(mimeType);
  
  NSMutableDictionary *mutableHeaders = [NSMutableDictionary dictionary];
  [mutableHeaders setValue:[NSString stringWithFormat:@"form-data; name=\"%@\"; filename=\"%@\"", name, fileName] forKey:@"Content-Disposition"];
  [mutableHeaders setValue:mimeType forKey:@"Content-Type"];
  
  
  AFHTTPBodyPart *bodyPart = [[AFHTTPBodyPart alloc] init];
  bodyPart.stringEncoding = self.stringEncoding;
  bodyPart.headers = mutableHeaders;
  bodyPart.boundary = self.boundary;
  bodyPart.body = inputStream;
  bodyPart.bodyContentLength = length;
  
  [self.bodyStream appendHTTPBodyPart:bodyPart];
}

- (void)appendPartWithFileData:(NSData *)data
                          name:(NSString *)name
                      fileName:(NSString *)fileName
                      mimeType:(NSString *)mimeType
{
  NSParameterAssert(name);
  NSParameterAssert(fileName);
  NSParameterAssert(mimeType);
  
  NSMutableDictionary *mutableHeaders = [NSMutableDictionary dictionary];
  [mutableHeaders setValue:[NSString stringWithFormat:@"form-data; name=\"%@\"; filename=\"%@\"", name, fileName] forKey:@"Content-Disposition"];
  [mutableHeaders setValue:mimeType forKey:@"Content-Type"];
  
  [self appendPartWithHeaders:mutableHeaders body:data];
}

- (void)appendPartWithFormData:(NSData *)data
                          name:(NSString *)name
{
  NSParameterAssert(name);
  
  NSMutableDictionary *mutableHeaders = [NSMutableDictionary dictionary];
  [mutableHeaders setValue:[NSString stringWithFormat:@"form-data; name=\"%@\"", name] forKey:@"Content-Disposition"];
  
  [self appendPartWithHeaders:mutableHeaders body:data];
}

- (void)appendPartWithHeaders:(NSDictionary *)headers
                         body:(NSData *)body
{
  NSParameterAssert(body);
  
  AFHTTPBodyPart *bodyPart = [[AFHTTPBodyPart alloc] init];
  bodyPart.stringEncoding = self.stringEncoding;
  bodyPart.headers = headers;
  bodyPart.boundary = self.boundary;
  bodyPart.bodyContentLength = [body length];
  bodyPart.body = body;
  
  [self.bodyStream appendHTTPBodyPart:bodyPart];
}

- (void)throttleBandwidthWithPacketSize:(NSUInteger)numberOfBytes
                                  delay:(NSTimeInterval)delay
{
  self.bodyStream.numberOfBytesInPacket = numberOfBytes;
  self.bodyStream.delay = delay;
}

- (NSMutableURLRequest *)requestByFinalizingMultipartFormData {
  if ([self.bodyStream isEmpty]) {
    return self.request;
  }
  
  // Reset the initial and final boundaries to ensure correct Content-Length
  [self.bodyStream setInitialAndFinalBoundaries];
  [self.request setHTTPBodyStream:self.bodyStream];
  
  [self.request setValue:[NSString stringWithFormat:@"multipart/form-data; boundary=%@", self.boundary] forHTTPHeaderField:@"Content-Type"];
  [self.request setValue:[NSString stringWithFormat:@"%lu", (unsigned long)[self.bodyStream contentLength]] forHTTPHeaderField:@"Content-Length"];
  
  return self.request;
}

- (NSInputStream *)createInputStream
{
  return [self bodyStream];
}

@end