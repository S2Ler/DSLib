//
//  DSMessageInterceptor.h
//  DSLib
//
//  Created by Alexander Belyavskiy on 3/30/14.
//  Copyright (c) 2014 DS ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DSAlertsSupportCode.h"

@class DSWebServiceParams;
@class DSInterceptedMessageMetadata;

/** Can intercept only messages without params */
@interface DSMessageInterceptor : NSObject<NSCopying>
/** Default yes */
@property (nonatomic, assign) BOOL isActive;
@property (nonatomic, strong) DSMessageDomain *domain;

/** You can set one code for domain */
@property (nonatomic, strong) DSMessageCode *code;
/** Or several codes for domain */
@property (nonatomic, strong) NSArray *codes;

@property (nonatomic, copy) void (^handler)(DSInterceptedMessageMetadata *metadata);

- (void)excludeParamsFromInterception:(Class)params;
- (BOOL)shouldInterceptParams:(DSWebServiceParams *)params;

@property (nonatomic, assign) BOOL shouldAllowOthersToProceed;
@end
