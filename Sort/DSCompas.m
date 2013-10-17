//
//  DSCompas.m
//  DSLib
//
//  Created by Alex on 16/10/2013.
//  Copyright (c) 2013 DS ltd. All rights reserved.
//

#import "DSCompas.h"
@import CoreLocation;

@interface DSCompas ()
@property (nonatomic, strong) CLLocationManager *locationManager;
@end

@implementation DSCompas

- (id)init
{
  self = [super init];
  if (self) {
    [self setup];
  }
  return self;
}

- (void)setup
{
  CLLocationManager *locationManager = [[CLLocationManager alloc] init];
  locationManager.delegate = self;
  if( [CLLocationManager locationServicesEnabled] &&  [CLLocationManager headingAvailable]) {
    [locationManager startUpdatingLocation];
    [locationManager startUpdatingHeading];
  } else {
    NSLog(@"Can't report heading");
  }
  [self setLocationManager:locationManager];
}

- (void)locationManager:(CLLocationManager *)manager
       didUpdateHeading:(CLHeading *)newHeading
{
  if (newHeading.headingAccuracy > 0) {
    float heading = -1.0f * M_PI * newHeading.magneticHeading / 180.0f;
    [self headingChangedHandler](self, heading, nil);
  }
}

- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error {
  if ([error code] == kCLErrorDenied) {
    // User has denied the application's request to use location services.
    [manager stopUpdatingHeading];
  } else if ([error code] == kCLErrorHeadingFailure) {
    // Heading could not be determined
  }
  
  [self headingChangedHandler](self, 0, error);
}

//- (float)magneticHeading:(float)heading
//         fromOrientation:(UIDeviceOrientation) orientation
//{
//  float realHeading = heading;
//  switch (orientation) {
//    case UIDeviceOrientationPortrait:
//      break;
//    case UIDeviceOrientationPortraitUpsideDown:
//      realHeading = realHeading + 180.0f;
//      break;
//    case UIDeviceOrientationLandscapeLeft:
//      realHeading = realHeading + 90.0f;
//      break;
//    case UIDeviceOrientationLandscapeRight:
//      realHeading = realHeading - 90.0f;
//      break;
//    default:
//      break;
//  }
//  while ( realHeading > 360.0f ) {
//    realHeading = realHeading - 360;
//  }
//  return realHeading;
//}
@end
