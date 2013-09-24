
#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import "DSPlacemarkPickerViewControllerDelegate.h"
#import "DSAlertsSupportCode.h"
@protocol DSGeocoderDelegate;


@interface DSGeocoder: NSObject<DSPlacemarkPickerViewControllerDelegate>
@property (nonatomic, weak) id<DSGeocoderDelegate> delegate;

- (void)cancelGeocode;

/** When this method returns a single placemark, the placemark is saved and can be accessed via savedPlacemarkForAddressString: message */
- (void)geocodeAddressString:(NSString *)addressString geocodeCompletionHandler:(CLGeocodeCompletionHandler)completionHandler;
- (void)geocodeAddressString:(NSString *)addressString completionHandler:(ds_results_completion)completion;
@end

@interface DSGeocoder(Abstract)
- (CLPlacemark *)savedPlacemarkForAddressString:(NSString *)addressString;
- (void)savePlacemark:(CLPlacemark *)placemark forAddressString:(NSString *)addressString;
@end
