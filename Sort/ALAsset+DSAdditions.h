//
//  ALAsset+DSAdditions.h
//  DSLib
//
//  Created by Alexander Belyavskiy on 3/12/14.
//  Copyright (c) 2014 DS ltd. All rights reserved.
//

#import <AssetsLibrary/AssetsLibrary.h>

#define COPY_BUFFER_SIZE 131072

@interface ALAsset (DSAdditions)
/** @return YES if success */
- (BOOL)copyToPath:(NSString *)path error:(NSError *__autoreleasing*)error;
@end
