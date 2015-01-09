//
//  NSOutputStream+DSAdditions.h
//  DSLib
//
//  Created by Alexander Belyavskiy on 3/12/14.
//  Copyright (c) 2014 DS ltd. All rights reserved.
//

@import Foundation;

@interface NSOutputStream (DSAdditions)
- (NSInteger)writeData:(NSData *)data error:(NSError *__autoreleasing*)error;
@end
