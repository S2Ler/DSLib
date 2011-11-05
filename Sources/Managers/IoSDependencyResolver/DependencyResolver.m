//
//  DependencyResolver.m
//  A6.nl
//
//  Created by Belyavskiy Alexander on 6/12/11.
//  Copyright 2011 HTApplications. All rights reserved.
//


#pragma mark - include
#import "DependencyResolver.h"
#import "DependencyResolver+Private.h"

static DependencyResolver *sharedInstance = nil;

@implementation DependencyResolver
#pragma mark - synth
@synthesize resolveMap = resolveMap_;

#pragma mark - singleton
+ (DependencyResolver *)sharedInstance {
	@synchronized(self) {
		if (sharedInstance == nil) {
			sharedInstance = [[DependencyResolver alloc] init];
		}
	}
	return sharedInstance;
}

+ (id)allocWithZone:(NSZone *)zone {
	@synchronized(self) {
		if (sharedInstance == nil) {
			sharedInstance = [super allocWithZone:zone];
			return sharedInstance;
		}
	}
	
	return nil;
}

- (id) init {
	self = [super init];
	if (self != nil) {		
    resolveMap_ = [[NSMutableDictionary alloc] init];
	}
	return self;
}

- (id)copyWithZone:(NSZone *)zone {
	return self;
}

- (id)retain {
	return self;
}

- (void)release {
	//do nothing
}

- (id)autorelease {
	return self;
}

#pragma mark - public
+ (Class)resolve:(Protocol *)theProtocol {
  DependencyResolver *instance = [self sharedInstance];
  NSValue *protocolObject = [NSValue valueWithPointer:theProtocol];
  return [[instance resolveMap] objectForKey:protocolObject];                                
}
@end
