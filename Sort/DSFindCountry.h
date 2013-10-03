
#import <Foundation/Foundation.h>
#import "DSAlertsSupportCode.h"

@interface DSFindCountry: NSObject

/** \returns array: first element is country code, second element is country name */
- (id)initWithResultBlock:(ds_results_completion)resultBlock;
- (void)startSearch;

@end
