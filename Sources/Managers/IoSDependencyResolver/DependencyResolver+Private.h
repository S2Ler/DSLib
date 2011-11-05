//
//  DependencyResolver+Private.h
//  A6.nl
//
//  Created by Belyavskiy Alexander on 6/12/11.
//  Copyright 2011 HTApplications. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DependencyResolver.h"

@interface DependencyResolver (Private)
+ (DependencyResolver *)sharedInstance;
@end

@interface DependencyResolver()
@property (nonatomic, retain) NSMutableDictionary *resolveMap;
@end
