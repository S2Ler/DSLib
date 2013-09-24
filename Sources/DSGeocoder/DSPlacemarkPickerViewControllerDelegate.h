
@class DSPlacemarkPickerViewController;

@protocol DSPlacemarkPickerViewControllerDelegate<NSObject>
- (void)placemarkPickerViewController:(DSPlacemarkPickerViewController *)thePicker
                     didPickPlacemark:(CLPlacemark *)placemark;
- (void)placemarkPickerViewController:(DSPlacemarkPickerViewController *)thePicker
          userCancelledPickPlacemarks:(NSArray *)placemarks;

@end
