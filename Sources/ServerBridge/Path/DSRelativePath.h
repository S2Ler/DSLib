//
//  DSRelativePath.h
//  DSLib
//
//  Created by Diejmon on 9/15/14.
//  Copyright (c) 2014 DS ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DSRelativePath : NSObject<NSCopying, NSCoding>
+ (instancetype)pathWithDirectory:(NSSearchPathDirectory)directory
                       domainMask:(NSSearchPathDomainMask)mask
                     relativePath:(NSString *)relativePath;

- (instancetype)initWithDirectory:(NSSearchPathDirectory)directory
                       domainMask:(NSSearchPathDomainMask)mask
                     relativePath:(NSString *)relativePath NS_DESIGNATED_INITIALIZER;

- (id)initWithCoder:(NSCoder *)aDecoder NS_DESIGNATED_INITIALIZER;


- (NSString *)fullPath;

- (instancetype)objectForKeyedSubscript:(NSString *)pathToAppend;
//- (void)setObject:(id)obj forKeyedSubscript:(id <NSCopying>)key;
@end
