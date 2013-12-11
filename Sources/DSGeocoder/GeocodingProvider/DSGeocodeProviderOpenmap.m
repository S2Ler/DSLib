//
//  DSGeocodeProviderOpenmap.m
//  DSLib
//
//  Created by Alex on 11/11/2013.
//  Copyright (c) 2013 DS ltd. All rights reserved.
//

#pragma mark - include
#import "DSGeocodeProviderOpenmap.h"
#import "JSONKit.h"
#import "DSPlacemark.h"

@implementation DSGeocodeProviderOpenmap

- (void)geocodeAddressString:(NSString *)addressString completionHandler:(DSGeocodeCompletionHandler)completionHandler
{
  
}

- (void)reverseGeocodeLocation:(CLLocation *)location completionHandler:(DSGeocodeCompletionHandler)completionHandler
{
  NSString *openmapReverseURLString = [NSString stringWithFormat:@"http://nominatim.openstreetmap.org/reverse?format=json&lat=%f&lon=%f&zoom=18&addressdetails=1", [location coordinate].latitude, [location coordinate].longitude];
  NSURL *openmapReverseURL = [NSURL URLWithString:openmapReverseURLString];
  NSURLRequest *request = [[NSURLRequest alloc] initWithURL:openmapReverseURL];
  [NSURLConnection sendAsynchronousRequest:request
                                     queue:[NSOperationQueue mainQueue]
                         completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
                           if (data) {
                             NSDictionary *json = [data objectFromJSONData];
                             NSArray *placemarks = [self placemarksFromJSON:json];
                             completionHandler(placemarks, nil);
                           }
                           else {
                             completionHandler(nil, connectionError);
                           }
                         }];
}

- (NSArray *)placemarksFromJSON:(NSDictionary *)json
{
  DSPlacemark *placemark = [[DSPlacemark alloc] init];
  
  [placemark setDisplayName:[json valueForKey:@"display_name"]];
  
  CLLocationCoordinate2D location;
  location.latitude = [[json valueForKey:@"lat"] doubleValue];
  location.longitude = [[json valueForKey:@"lon"] doubleValue];
  [placemark setLocation:location];
  
  
  NSDictionary *addressJSON = [json valueForKey:@"address"];
  [placemark setHouseNumber:[addressJSON valueForKey:@"house_number"]];
  [placemark setStreetAddress:[addressJSON valueForKey:@"road"]];
  [placemark setCity:[addressJSON valueForKey:@"city"]];
  [placemark setSuburb:[addressJSON valueForKey:@"suburb"]];
  [placemark setState:[addressJSON valueForKey:@"state"]];
  [placemark setStateDistrict:[addressJSON valueForKey:@"state_district"]];
  [placemark setPostalCode:[addressJSON valueForKey:@"postcode"]];
  [placemark setISOcountryCode:[addressJSON valueForKey:@"country_code"]];
  [placemark setCountry:[addressJSON valueForKey:@"country"]];
  
  return @[placemark];
}

- (void)cancelGeocode
{
  
}

@end
