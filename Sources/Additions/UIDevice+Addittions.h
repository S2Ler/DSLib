//
//  UIDevice+Addittions.h
//  FlipDrive
//
//  Created by Belyavskiy Alexander on 5/14/11.
//  Copyright 2011 FilpDrive.com. All rights reserved.
//

#import <Foundation/Foundation.h>

/** Query various device params */
@interface UIDevice (Addittions)

/** \return the system version of the current device */
+ (NSString *)deviceIOSVersion;

/** Query whether current device system version is greate or equal 
 then theIOSVersionToCompare */
+ (BOOL)isIOSVersionGreaterOrEqualTo:(NSString *)theIOSVersionToCompare;
@end
