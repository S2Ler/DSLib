
#pragma mark - include
#import "DSGeocoder.h"
#import "DSGeocoderDelegate.h"
#import "DSPlacemarkPickerViewController.h"
#import "NSArray+Extras.h"
#import "DSMessage.h"
#import "DSCFunctions.h"
#import "DSCLPlacemarkTransformer.h"
#import "DSGeocodeProvider.h"

#pragma mark - private
@interface DSGeocoder ()
@property (nonatomic, strong) id<DSGeocodeProvider> geocodeProvider;

@property (nonatomic, strong) CLGeocodeCompletionHandler completionHandler;

@end

@implementation DSGeocoder

- (void)dealloc
{
  [[self geocodeProvider] cancelGeocode];
}

- (id)initWithGeocodeProvider:(id<DSGeocodeProvider>)geocodeProvider
{
  self = [super init];
  if (self) {
    _geocodeProvider = geocodeProvider;
  }

  return self;
}

- (void)cancelGeocode
{
  [[self geocodeProvider] cancelGeocode];
}

#pragma mark - geocode
- (void)geocodeAddressString:(NSString *)addressString geocodeCompletionHandler:(CLGeocodeCompletionHandler)completionHandler
{
  NSAssert(completionHandler != nil, @"Completion shouldn't be nil", nil);

  __weak __block DSGeocoder *weakSelf = self;
  __weak __block id<DSGeocoderDelegate> weakDelegate = [self delegate];
  [[self geocodeProvider]
         geocodeAddressString:addressString
            completionHandler:^(NSArray *placemarks, NSError *error)
            {
              if ([placemarks count] <= 1) {
                if ([placemarks lastObject]) {
                  [self savePlacemark:[placemarks lastObject] forAddressString:addressString];
                }
                completionHandler(placemarks, error);
              }
              else {
                BOOL showPlacemarkPicker = NO;
                if ([weakDelegate respondsToSelector:@selector(isGeocoderShouldShowPickerIfMoreThanOnePlacemarkFoundForAddressString:)]) {
                  showPlacemarkPicker
                    = [weakDelegate isGeocoderShouldShowPickerIfMoreThanOnePlacemarkFoundForAddressString:weakSelf];
                }

                if (showPlacemarkPicker) {
                  [weakSelf setCompletionHandler:completionHandler];
                  DSPlacemarkPickerViewController *pickerViewController
                    = [[DSPlacemarkPickerViewController alloc] initWithPlacemarks:placemarks delegate:self];
                  [pickerViewController setDelegate:self];
                  [pickerViewController setUserInfo:@{@"addressString" : addressString}];
                  [weakDelegate geocoder:self wantToShowPickerViewController:pickerViewController];
                }
                else {
                  //No save as here placemarks has more than one placemark and we save only if there is only one placemark
                  completionHandler(placemarks, error);
                }
              }
            }];
}

- (void)geocodeAddressString:(NSString *)addressString completionHandler:(ds_results_completion)completion
{
  void (^placemarkHandler)(NSArray *, NSError *) = ^(NSArray *placemarks, NSError *error)
  {
    if (!error || ([[error domain]
                    isEqualToString:kCLErrorDomain] && ([error code] == kCLErrorGeocodeFoundNoResult || [error code] == kCLErrorGeocodeFoundPartialResult || [error code] == kCLErrorGeocodeCanceled))) {
      CLPlacemark *placemark = [placemarks lastObject];
      if (placemark) {
        completion(SUCCEED_WITH_MESSAGE, NO_MESSAGE, placemark);
      }
      else {
        completion(FAILED_WITH_MESSAGE, NO_MESSAGE, nil);
      }
    }
    else {
      completion(FAILED_WITH_MESSAGE, [DSMessage messageWithDomain:kCLErrorDomain code:[NSString stringWithFormat:@"%ld", (long)[error code]]], nil);
    }
  };
  
  CLPlacemark *savedPlacemarkForAddressString = [self savedPlacemarkForAddressString:addressString];
  if (savedPlacemarkForAddressString) {
    placemarkHandler(@[savedPlacemarkForAddressString], nil);
  }
  else {
    [self geocodeAddressString:addressString geocodeCompletionHandler:placemarkHandler];
  }
}

#pragma mark - reverse geocoder
- (void)reverseGeocodeLocation:(CLLocation *)location
      geocodeCompletionHandler:(CLGeocodeCompletionHandler)completionHandler
{
  NSAssert(completionHandler != nil, @"Completion shouldn't be nil", nil);
  
  __weak __block DSGeocoder *weakSelf = self;
  __weak __block id<DSGeocoderDelegate> weakDelegate = [self delegate];
  [[self geocodeProvider]
   reverseGeocodeLocation:location
   completionHandler:^(NSArray *placemarks, NSError *error)
   {
     if ([placemarks count] <= 1) {
       if ([placemarks lastObject]) {
         [self savePlacemark:[placemarks lastObject] forLocation:location];
       }
       completionHandler(placemarks, error);
     }
     else {
       BOOL showPlacemarkPicker = NO;
       if ([weakDelegate respondsToSelector:@selector(isGeocoderShouldShowPickerIfMoreThanOnePlacemarkFoundForAddressString:)]) {
         showPlacemarkPicker
         = [weakDelegate isGeocoderShouldShowPickerIfMoreThanOnePlacemarkFoundForAddressString:weakSelf];
       }
       
       if (showPlacemarkPicker) {
         [weakSelf setCompletionHandler:completionHandler];
         DSPlacemarkPickerViewController *pickerViewController
         = [[DSPlacemarkPickerViewController alloc] initWithPlacemarks:placemarks delegate:self];
         [pickerViewController setDelegate:self];
         [pickerViewController setUserInfo:@{@"location" : location}];
         [weakDelegate geocoder:self wantToShowPickerViewController:pickerViewController];
       }
       else {
         //No save as here placemarks has more than one placemark and we save only if there is only one placemark
         completionHandler(placemarks, error);
       }
     }
   }];

}
- (void)reverseGeocodeLocation:(CLLocation *)location
             completionHandler:(ds_results_completion)completionHandler
{
  void (^placemarkHandler)(NSArray *, NSError *) = ^(NSArray *placemarks, NSError *error)
  {
    if (!error || ([[error domain]
                    isEqualToString:kCLErrorDomain] && ([error code] == kCLErrorGeocodeFoundNoResult || [error code] == kCLErrorGeocodeFoundPartialResult || [error code] == kCLErrorGeocodeCanceled))) {
      CLPlacemark *placemark = [placemarks lastObject];
      if (placemark) {
        completionHandler(SUCCEED_WITH_MESSAGE, NO_MESSAGE, placemark);
      }
      else {
        completionHandler(FAILED_WITH_MESSAGE, NO_MESSAGE, nil);
      }
    }
    else {
      completionHandler(FAILED_WITH_MESSAGE, [DSMessage messageWithDomain:kCLErrorDomain code:[NSString stringWithFormat:@"%ld", (long)[error code]]], nil);
    }
  };
  
  CLPlacemark *savedPlacemarkForAddressString = [self savedPlacemarkForLocation:location];
  if (savedPlacemarkForAddressString) {
    placemarkHandler(@[savedPlacemarkForAddressString], nil);
  }
  else {
    [self reverseGeocodeLocation:location geocodeCompletionHandler:placemarkHandler];
  }
}

#pragma mark - DSPlacemarkPickerViewControllerDelegate
- (void)placemarkPickerViewController:(DSPlacemarkPickerViewController *)thePicker
                     didPickPlacemark:(CLPlacemark *)placemark
{
  NSAssert(placemark != nil, @"Delegate method sends nil placemark", nil);
  [self savePlacemark:placemark forAddressString:[[thePicker userInfo] valueForKey:@"addressString"]];
  [self completionHandler](@[placemark], nil);
}

- (void)placemarkPickerViewController:(DSPlacemarkPickerViewController *)thePicker
          userCancelledPickPlacemarks:(NSArray *)placemarks
{
  [self completionHandler](@[[placemarks firstObject]], [NSError errorWithDomain:kCLErrorDomain
                                                                            code:kCLErrorGeocodeCanceled
                                                                        userInfo:nil]);
}

#pragma mark - Cache data
//TODO: refactor to use https://github.com/ccgus/fmdb
- (void)savePlacemark:(CLPlacemark *)placemark forAddressString:(NSString *)addressString
{
  if (!addressString) {
    return;
  }
  
  NSData *transformedPlacemark = [[[DSCLPlacemarkTransformer alloc] init] transformedValue:placemark];
  [[NSUserDefaults standardUserDefaults] setObject:transformedPlacemark
                                            forKey:[self saveKeyForAddressString:addressString]];
}

- (void)savePlacemark:(CLPlacemark *)placemark forLocation:(CLLocation *)location
{
  //TODO:
}

- (CLPlacemark *)savedPlacemarkForAddressString:(NSString *)addressString
{
  NSData *placemarkData = [[NSUserDefaults standardUserDefaults] objectForKey:[self saveKeyForAddressString:addressString]];
  if (placemarkData) {
    CLPlacemark *placemark = [[[DSCLPlacemarkTransformer alloc] init] reverseTransformedValue:placemarkData];
    return placemark;
  }
  else {
    return nil;
  }
}

- (CLPlacemark *)savedPlacemarkForLocation:(CLLocation *)location
{
  return nil;
}

- (NSString *)saveKeyForAddressString:(NSString *)addressString
{
  return [NSString stringWithFormat:@"DSGeocoder-%@", addressString];
}

@end
