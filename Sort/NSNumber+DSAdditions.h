//
//  NSNumber+DSAdditions.h
//  DSLib
//
//  Created by Alexander Belyavskiy on 2/10/14.
//  Copyright (c) 2014 DS ltd. All rights reserved.
//

@import Foundation;
#import "DSConstants.h"

@interface NSNumber (DSAdditions)
- (DSFileSize)fileSizeValue;
+ (instancetype)numberWithFileSize:(DSFileSize)fileSize;

- (DSRecID)recIDValue;
+ (instancetype)numberWithRecID:(DSRecID)recID;
@end

