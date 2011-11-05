//
//  NSFileManager+Directories.h
//  GainFx Trade
//
//  Created by Alexander Belyavskiy on 7/5/11.
//  Copyright 2011 iTechArt. All rights reserved.
//

#import <Foundation/Foundation.h>

/** Easy access various directories */
@interface NSFileManager (NSFileManager_Directories)

/**
 \param theType the type of the directory to return
 \return path for the directory with NSUserDomainMask of type theType */
+ (NSString *)userDirectoryOfType:(NSSearchPathDirectory)theType;
@end
