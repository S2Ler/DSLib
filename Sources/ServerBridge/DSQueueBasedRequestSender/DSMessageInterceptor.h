//
//  DSMessageInterceptor.h
//  DSLib
//
//  Created by Alexander Belyavskiy on 3/30/14.
//  Copyright (c) 2014 DS ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DSAlertsSupportCode.h"

/** Can intercept only messages without params */
@interface DSMessageInterceptor : NSObject
@property (nonatomic, strong) DSMessageDomain *domain;
@property (nonatomic, strong) DSMessageCode *code;

- (void)setHandler:(ds_completion_handler)handler;
- (ds_completion_handler)handler;
@end
