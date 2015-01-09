
@import Foundation;
#import <MapKit/MapKit.h>


@interface DSChoosePlacemarkAnnotation: NSObject<MKAnnotation>
@property (nonatomic, readonly, copy) NSString *title;
@property (nonatomic, readonly, copy) NSString *subtitle;
@property (nonatomic, strong, readonly) CLPlacemark *placemark;

- (id)initWithPlacemark:(CLPlacemark *)placemark;

@end
