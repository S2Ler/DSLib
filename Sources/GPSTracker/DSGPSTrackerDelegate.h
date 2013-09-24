
#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@class DSGPSTracker;

@protocol DSGPSTrackerDelegate <NSObject>

/** 
 \param theDesiredAccuracyFlag show whether theLocation has the accuracy asked from theTracker 
 */
- (void)             gpsTracker:(DSGPSTracker *)theTracker
              didGetNewLocation:(CLLocation *)theLocation
  isLocationWithDesiredAccuracy:(BOOL)theDesiredAccuracyFlag;

/** this messages sends when access to location services is denied */
- (void)gpsTrackerIsDeniedAccess:(DSGPSTracker *)theTracker;

//- (void)gpsTracker:(DSGPSTracker *)theTracker
//  didFailWithError:(NSError *)theError;
                   

@end
