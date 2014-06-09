
#pragma mark - include
#import "DSGPSTracker.h"

#pragma mark - Private
@interface DSGPSTracker ()
{
  CLLocationManager *_locationManager;
}

@property (nonatomic, retain) CLLocation *currentLocation;
@property (nonatomic, assign) NSTimeInterval lastServerSyncTimestamp;
@property (nonatomic, assign) BOOL isUpdatingLocation;
@property (nonatomic, assign) BOOL shouldStopAfterObtainingLocation;
@property (nonatomic, copy) DSGPSTrackerBlock delegateBlock;

- (CLLocationManager *)locationManager;

@end

@implementation DSGPSTracker

- (void)dealloc
{
  [_locationManager stopUpdatingLocation];
  [[self class] cancelPreviousPerformRequestsWithTarget:self];
}

+ (DSGPSTracker *)sharedInstance
{
  static DSGPSTracker *sharedSingleton;

  @synchronized (self) {
    if (!sharedSingleton) {
      sharedSingleton = [[DSGPSTracker alloc] init];
    }
    return sharedSingleton;
  }
}

- (id)init
{
  self = [super init];
  if (self) {
    _desiredAccuracy = kCLLocationAccuracyThreeKilometers;
    _distanceFilter = 10;
    _delegateQueue = dispatch_get_main_queue();
  }
  return self;
}

- (CLLocationManager *)locationManager
{
  if (!_locationManager) {
    _locationManager = [[CLLocationManager alloc] init];
    [_locationManager setDelegate:self];
    [_locationManager setDistanceFilter:[self distanceFilter]];
    [_locationManager setDesiredAccuracy:[self desiredAccuracy]];
  }
  return _locationManager;
}

- (void)setDesiredAccuracy:(CLLocationAccuracy)theAccuracyOfMonitoring
{
  [[self locationManager] setDesiredAccuracy:theAccuracyOfMonitoring];
}

- (void)setCurrentLocation:(CLLocation *)currentLocation
{
  BOOL isLocationWithDesiredAccuracy = NO;
  if ([_currentLocation horizontalAccuracy] <= [self desiredAccuracy]) {
    isLocationWithDesiredAccuracy = YES;
  }

  if (currentLocation != _currentLocation) {
    _currentLocation = currentLocation;

    if (isLocationWithDesiredAccuracy && [self shouldStopAfterObtainingLocation] == YES) {
      [self deactivate];
    }
  }

  dispatch_async([self delegateQueue], ^{
    [[self delegate] gpsTracker:self
              didGetNewLocation:currentLocation
  isLocationWithDesiredAccuracy:isLocationWithDesiredAccuracy];
    if ([self delegateBlock]) {
      [self delegateBlock](self, currentLocation, isLocationWithDesiredAccuracy, NO);
    }
  });
}

#pragma mark - activation
- (void)startUpdatingLocation
{
  [[self locationManager] startUpdatingLocation];
  [self setIsUpdatingLocation:YES];
}

- (void)activate
{
  [self setShouldStopAfterObtainingLocation:NO];
  [self startUpdatingLocation];
}

- (void)deactivate
{
  [[self locationManager] stopUpdatingLocation];
  [self setIsUpdatingLocation:NO];
  _locationManager = nil;
}

- (void)getUserLocation
{
  if (_locationManager != nil && [self isUpdatingLocation] == YES) {
    return;
  }

  [self setShouldStopAfterObtainingLocation:YES];
  [self startUpdatingLocation];
}

- (void)scheduleGetUserLocationAfterTimeInterval:(NSTimeInterval)theInterval
{
  NSLog(@"interval: %f sec", theInterval);
  [self performSelector:@selector(getUserLocation)
             withObject:nil afterDelay:theInterval];
}

- (BOOL)isTrackingAvailable
{
  [self locationManager];//trigger creation if hasn't before 

  return [CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorized;
}

- (void)locationManager:(CLLocationManager *)manager
    didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation
{
  NSLog(@"DSGPSTracker: new location: {lat: %f}:{lon: %f}:{h.accuracy: %f}",
               newLocation.coordinate.latitude,
               newLocation.coordinate.longitude,
               newLocation.horizontalAccuracy);

  [self setCurrentLocation:newLocation];
}

- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error
{
  NSLog(@"%@", error);
  if ([error code] == kCLErrorDenied) {
    dispatch_async([self delegateQueue], ^{
      [[self delegate] gpsTrackerIsDeniedAccess:self];
      if ([self delegateBlock]) {
        [self delegateBlock](self, nil, NO, YES);
      }
    });
    [self deactivate];
  }
}

@end
