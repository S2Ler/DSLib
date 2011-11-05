//
//  DependencyResolver.h
//  A6.nl
//
//  Created by Belyavskiy Alexander on 6/12/11.
//  Copyright 2011 HTApplications. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface DependencyResolver : NSObject {
  NSMutableDictionary *resolveMap_;
}

+ (Class)resolve:(Protocol *)theProtocol;

@end
