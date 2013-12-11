//
//  DSGeocoder+Factory.h
//  DSLib
//
//  Created by Alex on 11/11/2013.
//  Copyright (c) 2013 DS ltd. All rights reserved.
//

#import "DSGeocoder.h"
#import "DSGeocodeProviderType.h"

@interface DSGeocoder (Factory)
+ (instancetype)geocoderWithGeocodeProviderType:(DSGeocodeProviderType)type;
@end
