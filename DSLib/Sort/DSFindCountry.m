
#import <CoreLocation/CoreLocation.h>
#import "DSFindCountry.h"
#import "DSMessage.h"

@interface DSFindCountry () <CLLocationManagerDelegate>

@property (nonatomic, copy) ds_results_completion resultBlock;
@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, strong) CLGeocoder *geoCoder;

@end

@implementation DSFindCountry

- (id)initWithResultBlock:(ds_results_completion)resultBlock {
  self = [super init];
  if (self) {
    [self setResultBlock:resultBlock];
  }

  return self;
}

- (void)dealloc {
  [self.locationManager stopUpdatingLocation];
  [self.geoCoder cancelGeocode];
}

- (void)startSearch {
  CLLocationManager *locationManager = [[CLLocationManager alloc] init];
  [self setLocationManager:locationManager];
  [locationManager setDesiredAccuracy:kCLLocationAccuracyThreeKilometers];
  [locationManager setDelegate:self];
  [locationManager startUpdatingLocation];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
  [self.locationManager stopUpdatingLocation];

  __block __weak DSFindCountry *weakSelf = self;
  CLGeocoder *geoCoder = [[CLGeocoder alloc] init];
  [self setGeoCoder:geoCoder];
  [geoCoder reverseGeocodeLocation:newLocation completionHandler:^(NSArray *placemark, NSError *error){
    if (error) {
      NSLog(@"Reverse geocode error:%@", error);
      if ([weakSelf resultBlock]) {
        [weakSelf resultBlock](FAILED_WITH_MESSAGE, [DSMessage messageWithError:error], NO_RESULTS);
      }
    } else if ([placemark count] > 0) {
      CLPlacemark *mark = [placemark objectAtIndex:0];
      if ([self resultBlock]) {
        [weakSelf resultBlock](SUCCEED_WITH_MESSAGE, NO_MESSAGE, @[[mark ISOcountryCode], [mark country]]);
      }
    }
  }];
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
  NSLog(@"Location get error:%@", error);
  [self.locationManager stopUpdatingLocation];
  if ([self resultBlock]) {
    [self resultBlock](FAILED_WITH_MESSAGE, [DSMessage messageWithError:error], NO_RESULTS);
  }
}

@end
