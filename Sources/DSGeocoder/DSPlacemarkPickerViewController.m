
#pragma mark - include
#import "DSPlacemarkPickerViewController.h"
#import "DSChoosePlacemarkAnnotation.h"
#import "NSString+Encoding.h"
#import "DSPlacemarkPickerViewControllerDelegate.h"
#import "DSMacros.h"

#pragma mark - private
@interface DSPlacemarkPickerViewController ()
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (nonatomic, strong) NSArray *placemarks;
@end

@implementation DSPlacemarkPickerViewController
- (id)initWithPlacemarks:(NSArray *)placemarks delegate:(id<DSPlacemarkPickerViewControllerDelegate>)delegate
{
  self = [super init];
  if (self) {
    _placemarks = placemarks;
  }
  return self;
}

- (void)viewDidLoad
{
  [super viewDidLoad];

  if ([self navigationController]) {
    [self setupNavigationController];
  }
  UNHANDLED_IF;
//  else {
//    [self setupOwnToolBar];
//  }

  [[self placemarks] enumerateObjectsUsingBlock:^(CLPlacemark *clPlacemark, NSUInteger idx, BOOL *stop)
  {
    NSAssert([clPlacemark isKindOfClass:[CLPlacemark class]], @"Wrong placemark: %@", clPlacemark);
    [[self mapView] addAnnotation:[[DSChoosePlacemarkAnnotation alloc] initWithPlacemark:clPlacemark]];
  }];
}

- (void)setupNavigationController
{
  [[self navigationItem] setHidesBackButton:YES];
  [[self navigationItem] setLeftBarButtonItem:[[UIBarButtonItem alloc]
                                                                initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
                                                                                     target:self
                                                                                     action:@selector(cancel)]];
}

- (void)dismiss
{
  if ([self navigationController]) {
    [[self navigationController] popViewControllerAnimated:YES];
  }
  else if ([self presentingViewController]) {
    [[self presentingViewController] dismissModalViewControllerAnimated:YES];
  }
  UNHANDLED_IF;
}

- (void)cancel
{
  [[self delegate] placemarkPickerViewController:self userCancelledPickPlacemarks:[self placemarks]];
  [self dismiss];
}

- (void)didReceiveMemoryWarning
{
  [super didReceiveMemoryWarning];
}

- (void)viewDidUnload
{
  [self setMapView:nil];
  [super viewDidUnload];
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
  MKAnnotationView *viewForAnnotation = nil;
  if ([annotation isKindOfClass:[DSChoosePlacemarkAnnotation class]] == NO) {
    return nil;
  }
  if ([mapView isEqual:[self mapView]] == NO) {
    return nil;
  }

  DSChoosePlacemarkAnnotation *placemark = (DSChoosePlacemarkAnnotation *)annotation;
  NSString *pinReusableIdentifier = @"PlacemarkID";
  MKPinAnnotationView *annotationView
    = (MKPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:pinReusableIdentifier];
  if (annotationView == nil) {
    annotationView = [[MKPinAnnotationView alloc] initWithAnnotation:placemark
                                                     reuseIdentifier:pinReusableIdentifier];
    [annotationView setCanShowCallout:YES];
  }

  UIButton *confirmButton = [UIButton buttonWithType:UIButtonTypeCustom];
  [confirmButton setFrame:CGRectMake(0, 0, 23, 23)];
  [confirmButton setImage:[@"checkMark" image] forState:UIControlStateNormal];
  [annotationView setRightCalloutAccessoryView:confirmButton];

  viewForAnnotation = annotationView;

  return viewForAnnotation;
}

- (void)mapView:(MKMapView *)mapView
               annotationView:(MKAnnotationView *)view
calloutAccessoryControlTapped:(UIControl *)control
{
  DSChoosePlacemarkAnnotation *annotation = (DSChoosePlacemarkAnnotation *)[view annotation];
  if ([annotation isKindOfClass:[DSChoosePlacemarkAnnotation class]]) {
    [[self delegate] placemarkPickerViewController:self didPickPlacemark:[annotation placemark]];
    [self dismiss];
  }
}


@end
