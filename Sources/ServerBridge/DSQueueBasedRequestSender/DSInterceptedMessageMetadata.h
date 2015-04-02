//
//  DSInterceptedMessageMetadata.h
//  DSLib
//
//  Created by Alexander Belyavskiy on 4/2/15.
//  Copyright (c) 2015 DS ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@class DSMessage;
@class DSWebServiceParams;

@interface DSInterceptedMessageMetadata : NSObject
@property (nonatomic, strong) DSMessage *message;
@property (nonatomic, strong) DSWebServiceParams *params;
@end
