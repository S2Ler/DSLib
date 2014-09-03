//
//  NSDate+TimeAgoFormatter.h
//  Amoretto
//
//  Created by Alexander Belyavskiy on 5/28/14.
//  Copyright (c) 2014 Morphia. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (TimeAgoFormatter)
- (NSString *)getTimeAgoStringShort;
- (NSString *)getTimeAgoStringLong;
+ (NSString *)testAM_getTimeAgoStringLong;
@end

