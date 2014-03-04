//
//  AFFunctions.h
//  DSLib
//
//  Created by Alexander Belyavskiy on 3/4/14.
//  Copyright (c) 2014 DS ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString * const kAFMultipartFormCRLF;
extern NSString * const AFNetworkingErrorDomain;


NSString * AFCreateMultipartFormBoundary(void);
NSString * AFMultipartFormInitialBoundary(NSString *boundary);
NSString * AFMultipartFormEncapsulationBoundary(NSString *boundary);
NSString * AFMultipartFormFinalBoundary(NSString *boundary);
NSString * AFContentTypeForPathExtension(NSString *extension);
