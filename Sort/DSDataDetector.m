
#import "DSDataDetector.h"
#import "NSArray+Extras.h"

@implementation DSDataDetector
- (NSString *)urlFromString:(NSString *)string
{
  NSError *error = nil;
  NSDataDetector *dataDetector = [NSDataDetector dataDetectorWithTypes:(NSTextCheckingTypes)NSTextCheckingTypeLink
                                                                 error:&error];
  if (!dataDetector) {
    NSLog(@"Failed to create data detector: %@", dataDetector);
    return nil;
  }

  NSArray *matches = [dataDetector matchesInString:string
                                           options:(NSMatchingOptions)kNilOptions
                                             range:NSMakeRange(0, [string length])];
  if ([matches count]) {
    return [[(NSTextCheckingResult *)[matches firstObject] URL] absoluteString];
  }
  else {
    return nil;
  }
}


@end
