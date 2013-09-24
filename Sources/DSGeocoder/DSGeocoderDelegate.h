
@class DSGeocoder;

@protocol DSGeocoderDelegate<NSObject>
- (void)geocoder:(DSGeocoder *)geocoder wantToShowPickerViewController:(UIViewController *)viewController;

@optional
/** Default is NO */
- (BOOL)isGeocoderShouldShowPickerIfMoreThanOnePlacemarkFoundForAddressString:(DSGeocoder *)geocoder;
@end
