//
//  DSPlacemark.h
//  DSLib
//
//  Created by Alex on 11/11/2013.
//  Copyright (c) 2013 DS ltd. All rights reserved.
//

@import Foundation;
@import CoreLocation;

@interface DSPlacemark : NSObject
- (id)initWithCLPlacemark:(CLPlacemark *)placemark;

//@property (nonatomic, readonly) NSString *subThoroughfare; // eg. 1
//@property (nonatomic, readonly) NSString *thoroughfare; // street address, eg. 1 Infinite Loop
//@property (nonatomic, readonly) NSString *locality; // city, eg. Cupertino
//@property (nonatomic, readonly) NSString *administrativeArea; // state, eg. CA
//@property (nonatomic, readonly) NSString *subAdministrativeArea; // county, eg. Santa Clara
//@property (nonatomic, readonly) NSString *postalCode; // zip code, eg. 95014
//@property (nonatomic, readonly) NSString *ISOcountryCode; // eg. US
//@property (nonatomic, readonly) NSString *country; // eg. United States

@property (nonatomic, assign) CLLocationCoordinate2D location;

@property (nonatomic, strong) NSString *displayName;

@property (nonatomic, strong) NSString *houseNumber; // eg. 1
@property (nonatomic, strong) NSString *streetAddress; // street address, eg. 1 Infinite Loop
@property (nonatomic, strong) NSString *city; // city, eg. Cupertino
@property (nonatomic, strong) NSString *suburb;
@property (nonatomic, strong) NSString *state; // state, eg. CA
@property (nonatomic, strong) NSString *stateDistrict;
@property (nonatomic, strong) NSString *postalCode; // zip code, eg. 95014
@property (nonatomic, strong) NSString *ISOcountryCode; // eg. US
@property (nonatomic, strong) NSString *country; // eg. United States

@end
