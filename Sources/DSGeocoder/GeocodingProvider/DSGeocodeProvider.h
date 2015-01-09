//
//  DSGeocodeProvider.h
//  DSLib
//
//  Created by Alex on 11/11/2013.
//  Copyright (c) 2013 DS ltd. All rights reserved.
//

@import Foundation;
@import CoreLocation;

/** @param placemarks - array of DSPlacemark */
typedef void (^DSGeocodeCompletionHandler)(NSArray *placemarks, NSError *error);

@protocol DSGeocodeProvider <NSObject>
- (void)geocodeAddressString:(NSString *)addressString
           completionHandler:(DSGeocodeCompletionHandler)completionHandler;
- (void)reverseGeocodeLocation:(CLLocation *)location
             completionHandler:(DSGeocodeCompletionHandler)completionHandler;
- (void)cancelGeocode;
@end
