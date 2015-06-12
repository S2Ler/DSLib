//
//  NSDate+TimeAgoFormatter.m
//  Amoretto
//
//  Created by Alexander Belyavskiy on 5/28/14.
//  Copyright (c) 2014 Morphia. All rights reserved.
//

#import "NSDate+TimeAgoFormatter.h"
#import <DSLibFramework/DSTimeFunctions.h>
#import <DSLibFramework/DSMacros.h>
#import "NSDate+DateTools.h"
#import <syslog.h>

@implementation NSDate (TimeAgoFormatter)

+ (NSDateFormatter *)yesterdayDateFormatter
{
  DEFINE_SHARED_INSTANCE_USING_BLOCK(^{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:[NSDateFormatter dateFormatFromTemplate:@"jjmm"
                                                                 options:0
                                                                  locale:[NSLocale autoupdatingCurrentLocale]]];
    return dateFormatter;
  });
}

+ (NSDateFormatter *)timeDateFormatter
{
  DEFINE_SHARED_INSTANCE_USING_BLOCK(^{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:[NSDateFormatter dateFormatFromTemplate:@"jjmm"
                                                                 options:0
                                                                  locale:[NSLocale autoupdatingCurrentLocale]]];
    return dateFormatter;
  });
}

+ (NSDateFormatter *)weekdayDateFormatter
{
  DEFINE_SHARED_INSTANCE_USING_BLOCK(^{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:[NSDateFormatter dateFormatFromTemplate:@"EEE"
                                                                 options:0
                                                                  locale:[NSLocale autoupdatingCurrentLocale]]];
    return dateFormatter;
  });
}

+ (NSDateFormatter *)monthDayDateFormatter
{
  DEFINE_SHARED_INSTANCE_USING_BLOCK(^{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:[NSDateFormatter dateFormatFromTemplate:@"ddMMM"
                                                                 options:0
                                                                  locale:[NSLocale autoupdatingCurrentLocale]]];
    return dateFormatter;
  });
}

+ (NSDateFormatter *)fullShortDateFormatter
{
  DEFINE_SHARED_INSTANCE_USING_BLOCK(^{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:[NSDateFormatter dateFormatFromTemplate:@"ddMMyyyy"
                                                                 options:0
                                                                  locale:[NSLocale autoupdatingCurrentLocale]]];
    return dateFormatter;
  });
}


+ (NSDateFormatter *)fullDateFormatter
{
  DEFINE_SHARED_INSTANCE_USING_BLOCK(^{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateStyle = NSDateFormatterMediumStyle;
    dateFormatter.timeStyle = NSDateFormatterShortStyle;
    return dateFormatter;
  });
}

- (NSString *)getTimeAgoStringShort
{
  return [NSDate am_getTimeAgoStringLong:NO now:[NSDate date] ago:self];
}

+ (NSString *)am_getTimeAgoStringLong:(BOOL)isLong now:(NSDate *)now ago:(NSDate *)startDate
{
  NSCalendar *calendar = [NSCalendar currentCalendar];
  

  NSTimeInterval ago = [now timeIntervalSinceDate:startDate];
  
  unsigned long minutesAgo = ago/60;
  unsigned long hoursAgo = minutesAgo/60;
  
  if (ago < NSTimeIntervalWithSeconds(60)) {
    return NSLocalizedString(@"time.ago.just_now", nil);
  }
  else if (ago < NSTimeIntervalWithSeconds(120)) {
    return NSLocalizedString(@"time.ago.minute", nil);
  }
  else if (ago < NSTimeIntervalWithMinutes(60)) {
    return [self logicLocalizedStringFromFormat:@"time.ago.%@Minutes" withValue:minutesAgo];
  }
  else if (ago < NSTimeIntervalWithHours(2)) {
    return NSLocalizedString(@"time.ago.hour", nil);
  }
  else if (ago < NSTimeIntervalWithHours(24)) {
    return [self logicLocalizedStringFromFormat:@"time.ago.%@Hours" withValue:hoursAgo];
  }
  else if ([startDate isYesterday]) {
    if (isLong) {
      return [NSString stringWithFormat:@"%@ %@ %@",
              NSLocalizedString(@"time.ago.yersterday", nil),
              NSLocalizedString(@"time.ago.at", nil),
              [[self yesterdayDateFormatter] stringFromDate:startDate]];
    }
    else {
      return NSLocalizedString(@"time.ago.yersterday", nil);
    }
  }
  else if ([now daysFrom:startDate calendar:calendar] == 1) {
    return NSLocalizedString(@"time.ago.1day", nil);
  }
  else if ([now daysFrom:startDate calendar:calendar] < 7) {
    return [self logicLocalizedStringFromFormat:@"time.ago.%@Days"
                                      withValue:[now daysFrom:startDate calendar:calendar]];
  }
  else if ([now weeksFrom:startDate calendar:calendar] == 1) {
    return NSLocalizedString(@"time.ago.1week", nil);
  }
  else if ([now monthsFrom:startDate calendar:calendar] == 0) {
    return [self logicLocalizedStringFromFormat:@"time.ago.%@Weeks"
                                      withValue:[now weeksFrom:startDate calendar:calendar]];
  }
  else if ([now monthsFrom:startDate calendar:calendar] == 1) {
    return NSLocalizedString(@"time.ago.1month", nil);
  }
  else if ([now yearsFrom:startDate calendar:calendar] == 0) {
    return [self logicLocalizedStringFromFormat:@"time.ago.%@Months"
                                      withValue:[now monthsFrom:startDate calendar:calendar]];
  }
  else if ([now yearsFrom:startDate calendar:calendar] == 1) {
    return NSLocalizedString(@"time.ago.1year", nil);
  }
  else {
    return [self logicLocalizedStringFromFormat:@"time.ago.%@Years"
                                      withValue:[now yearsFrom:startDate calendar:calendar]];
  }
  
  return @"";
}

+ (NSString *)logicLocalizedStringFromFormat:(NSString *)format withValue:(NSInteger)value
{
  NSString *localeFormat = [NSString stringWithFormat:format, [self getLocaleFormatXWithValue:value]];
  return [NSString stringWithFormat:NSLocalizedString(localeFormat, nil), value];
}

+ (NSString *)getLocaleFormatXWithValue:(double)value
{
  NSString *localeCode = [[[NSBundle mainBundle] preferredLocalizations] objectAtIndex:0];
  
  // Russian (ru) and Ukrainian (uk)
  if([localeCode isEqual:@"ru"] || [localeCode isEqual:@"uk"]) {
    int XY = (int)floor(value) % 100;
    int Y = (int)floor(value) % 10;
    
    if(Y == 0 || Y > 4 || (XY > 10 && XY < 15)) {
      return @"x";
    }
    
    if(Y > 1 && Y < 5 && (XY < 10 || XY > 20))  {
      return @"xx";
    }
    
    if(Y == 1 && XY != 11) {
      return @"xxx";
    }
  }
  
  // Add more languages here, which are have specific translation rules...
  
  return @"x";
}

- (NSString *)getTimeAgoStringLong
{
  return [[self class] am_getTimeAgoForMessagesStringWithNow:[NSDate date] ago:self];
}

+ (NSString *)am_getTimeAgoForMessagesStringWithNow:(NSDate *)now ago:(NSDate *)startDate
{
  if ([startDate isToday]) {
    return [NSString stringWithFormat:@"%@ %@",
            NSLocalizedString(@"time.today", nil),
            [[self yesterdayDateFormatter] stringFromDate:startDate]];
  }
  else if ([startDate isYesterday]) {
    return [NSString stringWithFormat:@"%@ %@",
            NSLocalizedString(@"time.yesterday", nil),
            [[self yesterdayDateFormatter] stringFromDate:startDate]];
  }
  else {
    return [[self fullDateFormatter] stringFromDate:startDate];
  }
}

- (NSString *)getShortDateString
{
  if ([self isToday]) {
    return [[[self class] timeDateFormatter] stringFromDate:self];
  }
  else if (fabs([self timeIntervalSinceNow]) < 60*60*24*6 + [[NSDate date] hour] * 60 *60) {
    return [[[self class] weekdayDateFormatter] stringFromDate:self];
  }
  else if (self.year == [NSDate date].year) {
    return [[[self class] monthDayDateFormatter] stringFromDate:self];
  }
  else {
    return [[[self class] fullShortDateFormatter] stringFromDate:self];
  }
}

#undef NSLog
#define NSLog(FORMAT, ...) printf("%s\n", [[NSString stringWithFormat:FORMAT, ##__VA_ARGS__] UTF8String]);
+ (NSString *)testAM_getTimeAgoStringLong
{
  NSDate *now = [NSDate date];
  NSString *lastTimeAgo = nil;
  for (NSTimeInterval seconds = 1; seconds < NSTimeIntervalWithDays(365*3); seconds+=60) {
    @autoreleasepool {
      NSDate *matchDate = [now dateBySubtractingSeconds:seconds];
      NSString *timeAgo = [NSDate am_getTimeAgoStringLong:NO
                                                      now:now
                                                      ago:matchDate];
      if ([timeAgo isEqualToString:lastTimeAgo]) {
        continue;
      }
      
      NSLog(@"%@ %@", matchDate, timeAgo);
      lastTimeAgo = timeAgo;
    }
  }
  return nil;
}
@end
