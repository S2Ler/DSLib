//
//  DSPlacemark.m
//  DSLib
//
//  Created by Alex on 11/11/2013.
//  Copyright (c) 2013 DS ltd. All rights reserved.
//

#import "DSPlacemark.h"

@implementation DSPlacemark
- (id)initWithCLPlacemark:(CLPlacemark *)placemark
{
  self = [super init];
  if (self) {
    _houseNumber = [placemark subThoroughfare];
    _streetAddress = [placemark thoroughfare];
    _city = [placemark locality];
    _state = [placemark administrativeArea];
    _postalCode = [placemark postalCode];
    _ISOcountryCode = [placemark ISOcountryCode];
    _country = [placemark country];
    _location = [[placemark location] coordinate];
  }
  return self;
}
@end
