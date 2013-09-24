
#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@protocol DSPlacemarkPickerViewControllerDelegate;

@interface DSPlacemarkPickerViewController : UIViewController<MKMapViewDelegate>
@property (nonatomic, weak) id<DSPlacemarkPickerViewControllerDelegate> delegate;
@property (nonatomic, strong) NSDictionary *userInfo;

- (id)initWithPlacemarks:(NSArray *)placemarks delegate:(id<DSPlacemarkPickerViewControllerDelegate>)delegate;
@end
