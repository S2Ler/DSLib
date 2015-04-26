//
//  DSInterceptorsMap.h
//  DSLib
//
//  Created by Alexander Belyavskiy on 4/2/15.
//  Copyright (c) 2015 DS ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@class DSMessageInterceptor;
@class DSMessage;

@interface DSInterceptorsMap : NSObject
- (void)addInterceptor:(DSMessageInterceptor *)interceptor;
- (void)removeInterceptor:(DSMessageInterceptor *)interceptor;
- (NSMutableArray *)interceptorsForMessage:(DSMessage *)message;
@end
