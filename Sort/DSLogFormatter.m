#import "DSLogFormatter.h"
#import <DSLib/DSMacros.h>

@implementation DSLogFormatter

+ (NSDateFormatter *)dateFormatter
{
  DEFINE_SHARED_INSTANCE_USING_BLOCK(^{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setTimeStyle:NSDateFormatterMediumStyle];
    [dateFormatter setDateStyle:NSDateFormatterShortStyle];
    return dateFormatter;
  })
}

- (NSString *)formatLogMessage:(DDLogMessage *)logMessage
{
  NSString *logLevel;
  switch (logMessage->logFlag)
  {
    case LOG_FLAG_ERROR : logLevel = @"ERROR"; break;
    case LOG_FLAG_WARN  : logLevel = @"WARNING"; break;
    case LOG_FLAG_INFO  : logLevel = @"INFO"; break;
    default             : logLevel = @"VERBOSE"; break;
  }
  
	return [NSString stringWithFormat:@"%@: [%@:%u] [%@  %s]: %@",
          [[[self class] dateFormatter] stringFromDate:logMessage->timestamp],
          logLevel,
          logMessage->machThreadID,
          [logMessage fileName],
          logMessage->function, 
          logMessage->logMsg];
}

@end
