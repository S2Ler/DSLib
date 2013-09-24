
#pragma mark - include
#import <AddressBookUI/AddressBookUI.h>
#import "DSChoosePlacemarkAnnotation.h"

#pragma mark - private
@interface DSChoosePlacemarkAnnotation()
@property (nonatomic, strong) CLPlacemark *placemark;
@end


@implementation DSChoosePlacemarkAnnotation
- (id)initWithPlacemark:(CLPlacemark *)placemark
{
  self = [super init];
  if (self) {
    _placemark = placemark;
  }
  return self;
}

- (NSString *)title
{
  return NSLocalizedStringFromTable(@"UI.chooseplacemark.annotation.title", @"DSChoosePlacemarkAnnotation", nil);
}

- (NSString *)subtitle
{
  return ABCreateStringWithAddressDictionary([[self placemark] addressDictionary], NO);
}

- (CLLocationCoordinate2D)coordinate
{
  return [[[self placemark] location] coordinate];
}

@end
