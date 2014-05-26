
#import "TestFlightLogger.h"
#import "TestFlight.h"

#if ! __has_feature(objc_arc)
#warning This file must be compiled with ARC. Use -fobjc-arc flag (or convert project to ARC).
#endif

@implementation TestFlightLogger

static TestFlightLogger *sharedInstance;

+ (void)initialize
{
	static BOOL initialized = NO;
	if (!initialized)
	{
		initialized = YES;
		
		sharedInstance = [[TestFlightLogger alloc] init];
	}
}

+ (TestFlightLogger *)sharedInstance
{
	return sharedInstance;
}

- (id)init
{
	if (sharedInstance != nil)
	{
		return nil;
	}
	
	if (self = [super init])
	{
        NSMutableDictionary *options = [NSMutableDictionary dictionary];
        [options setValue:[NSNumber numberWithBool:NO] forKey:@"logToConsole"];
        [options setValue:[NSNumber numberWithBool:NO] forKey:@"logToSTDERR"];
        [TestFlight setOptions:options];
	}
	return self;
}

- (void)logMessage:(DDLogMessage *)logMessage
{
    NSString *logMsg = logMessage->logMsg;
    
    if (formatter)
        logMsg = [formatter formatLogMessage:logMessage];
    
    if (logMsg)
    {
        TFLog(@"%@", logMsg);
    }
}

- (NSString *)loggerName
{
	return @"cocoa.lumberjack.testflightlogger";
}

@end
