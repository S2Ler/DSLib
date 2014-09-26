//
//  DSRelativePath.m
//  DSLib
//
//  Created by Diejmon on 9/15/14.
//  Copyright (c) 2014 DS ltd. All rights reserved.
//

#pragma mark - include
#import "DSRelativePath.h"

#pragma mark - interface

@interface DSRelativePath ()
@property (nonatomic, assign) NSSearchPathDirectory searchDirectory;
@property (nonatomic, assign) NSSearchPathDomainMask searchDomainMask;
@property (nonatomic, copy) NSString *relativePath;
@end

@implementation DSRelativePath

#pragma mark - init
+ (instancetype)pathWithDirectory:(NSSearchPathDirectory)directory
                       domainMask:(NSSearchPathDomainMask)mask
                     relativePath:(NSString *)relativePath
{
  return [[self alloc] initWithDirectory:directory domainMask:mask relativePath:relativePath];
}

- (instancetype)initWithDirectory:(NSSearchPathDirectory)directory
                       domainMask:(NSSearchPathDomainMask)mask
                     relativePath:(NSString *)relativePath
{
  NSParameterAssert(relativePath);
  
  self = [super init];
  if (self) {
    _searchDirectory = directory;
    _searchDomainMask = mask;
    _relativePath = relativePath;
  }
  return self;
}

- (instancetype)init
{
  self = [self initWithDirectory:NSCachesDirectory
                      domainMask:NSUserDomainMask
                    relativePath:@""];

  return self;
}

- (instancetype)copyWithZone:(NSZone *)zone
{
  DSRelativePath *copy = [[[self class] alloc] initWithDirectory:self.searchDirectory
                                                      domainMask:self.searchDomainMask
                                                    relativePath:self.relativePath];
  return copy;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
  [aCoder encodeInteger:self.searchDirectory forKey:@"searchDirectory"];
  [aCoder encodeInteger:self.searchDomainMask forKey:@"searchDomainMask"];
  [aCoder encodeObject:self.relativePath forKey:@"relativePath"];
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
  self = [super init];
  if (self) {
    _searchDirectory = [aDecoder decodeIntegerForKey:@"searchDirectory"];
    _searchDomainMask = [aDecoder decodeIntegerForKey:@"searchDomainMask"];
    _relativePath = [aDecoder decodeObjectForKey:@"relativePath"];
  }
  return self;
}

#pragma mark - Public
- (NSString *)fullPath
{
  NSString *rootLocation = [NSSearchPathForDirectoriesInDomains(self.searchDirectory, self.searchDomainMask, YES) firstObject] ;
  if (rootLocation) {
    NSString *fullPath = [rootLocation stringByAppendingPathComponent:[self relativePath]];
    return fullPath;
  }
  
  return nil;
}

- (instancetype)objectForKeyedSubscript:(NSString *)pathToAppend
{
  DSRelativePath *copy = [self copy];
  copy.relativePath = [copy.relativePath stringByAppendingPathComponent:pathToAppend];
  return copy;
}

- (instancetype)relativePathByRemovingLastPathComponent
{
  DSRelativePath *copy = [self copy];
  copy.relativePath = [copy.relativePath stringByDeletingLastPathComponent];
  return copy;
}

#pragma mark - Debug
- (NSString *)debugDescription
{
  return [self fullPath];
}
@end
