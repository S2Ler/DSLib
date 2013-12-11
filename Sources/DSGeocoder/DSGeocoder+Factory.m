//
//  DSGeocoder+Factory.m
//  DSLib
//
//  Created by Alex on 11/11/2013.
//  Copyright (c) 2013 DS ltd. All rights reserved.
//

#pragma mark - include
#import "DSGeocoder+Factory.h"
#import "DSGeocodeProviderApple.h"
#import "DSGeocodeProviderOpenmap.h"

@implementation DSGeocoder (Factory)
+ (instancetype)geocoderWithGeocodeProviderType:(DSGeocodeProviderType)type
{
  id<DSGeocodeProvider> provider = nil;
  switch (type) {
    case DSGeocodeProviderTypeApple:
      NSAssert(FALSE, @"Implement apple provider if you need it");
      break;
    case DSGeocodeProviderTypeGoogle:
      NSAssert(FALSE, @"Implement google provider if you need it");
    case DSGeocodeProviderTypeOpenmap:
      provider = [[DSGeocodeProviderOpenmap alloc] init];
    default:
      break;
  }
  
  return [[self alloc] initWithGeocodeProvider:provider];;
}
@end
