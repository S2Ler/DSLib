
#import <Foundation/Foundation.h>
#import "DDLog.h"

/**
 * This class provides a logger for TestFlight.
 **/

@interface TestFlightLogger : DDAbstractLogger <DDLogger>

+ (TestFlightLogger *)sharedInstance;

@end
