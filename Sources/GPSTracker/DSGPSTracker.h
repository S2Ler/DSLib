
#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import "DSGPSTrackerDelegate.h"

/*
- (void)             gpsTracker:(DSGPSTracker *)theTracker
              didGetNewLocation:(CLLocation *)theLocation
  isLocationWithDesiredAccuracy:(BOOL)theDesiredAccuracyFlag;
 */
typedef void (^DSGPSTrackerBlock)(DSGPSTracker *gpsTracker, CLLocation *location, BOOL desiredAccuracyFlag, BOOL accessDenied);

@interface DSGPSTracker : NSObject<CLLocationManagerDelegate> 

@property (nonatomic, weak) id<DSGPSTrackerDelegate> delegate;
- (void)setDelegateBlock:(DSGPSTrackerBlock)delegateBlock;
- (void)setFailedBlock:(void(^)(NSError *))failedBlock;
/** Default is main queue */
@property (nonatomic, strong) dispatch_queue_t delegateQueue;

/** Default is Three Kilometers */
@property (nonatomic, assign) CLLocationAccuracy desiredAccuracy;
/** Default is 10 meters */
@property (nonatomic, assign) CLLocationDistance distanceFilter;

- (BOOL)isTrackingAvailable;
- (BOOL)isTrackingAvailableInBackground;

+ (DSGPSTracker *)sharedInstance;

/** Activate GPS Tracking module */
- (void)activate;
/** Deactivate GPS Tracking module */
- (void)deactivate;
/**
 * If GPS Tracker inactive it will activate it until desiredAccuracy will be reached and 
 deactivate it after that.
 * If GPS Tracker active it doesn't have any effect.
 */
- (void)getUserLocation;

/** Run getUserLocation after specific time interval */
- (void)scheduleGetUserLocationAfterTimeInterval:(NSTimeInterval)theInterval;

- (CLLocation *)currentLocation;

@end
