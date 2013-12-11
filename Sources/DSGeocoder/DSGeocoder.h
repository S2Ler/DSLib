
#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import "DSPlacemarkPickerViewControllerDelegate.h"
#import "DSAlertsSupportCode.h"
#import "DSGeocodeProvider.h"
@protocol DSGeocoderDelegate;


@interface DSGeocoder: NSObject<DSPlacemarkPickerViewControllerDelegate>
@property (nonatomic, weak) id<DSGeocoderDelegate> delegate;

- (id)initWithGeocodeProvider:(id<DSGeocodeProvider>)geocodeProvider;

- (void)cancelGeocode;

/** When this method returns a single placemark, the placemark is saved and can be accessed via savedPlacemarkForAddressString: message */
- (void)geocodeAddressString:(NSString *)addressString geocodeCompletionHandler:(CLGeocodeCompletionHandler)completionHandler;
- (void)geocodeAddressString:(NSString *)addressString completionHandler:(ds_results_completion)completion;

- (void)reverseGeocodeLocation:(CLLocation *)location geocodeCompletionHandler:(CLGeocodeCompletionHandler)completionHandler;
- (void)reverseGeocodeLocation:(CLLocation *)location completionHandler:(ds_results_completion)completionHandler;
@end

@interface DSGeocoder(Abstract)
/** Default implementation saves CLPlacemark to NSUserDefaults */
- (CLPlacemark *)savedPlacemarkForAddressString:(NSString *)addressString;
/** Default implementation saves CLPlacemark to NSUserDefaults */
- (void)savePlacemark:(CLPlacemark *)placemark forAddressString:(NSString *)addressString;
@end
