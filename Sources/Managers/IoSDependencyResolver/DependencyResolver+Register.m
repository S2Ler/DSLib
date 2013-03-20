//
//  DependencyResolver+Register.m
//  A6.nl
//
//  Created by Belyavskiy Alexander on 6/12/11.
//  Copyright 2011 HTApplications. All rights reserved.
//

#import "DependencyResolver+Register.h"
#import "DependencyResolver+Private.h"


@implementation DependencyResolver (Register)
+ (void)addClass:(Class)theConcreteClass
     forProtocol:(Protocol *)theProtocol {  
  DependencyResolver *instance = [self sharedInstance];
  NSValue *protocolObject = [NSValue valueWithPointer:( const void *)(theProtocol)];
  [[instance resolveMap] setObject:theConcreteClass
                            forKey:protocolObject];

}

@end
