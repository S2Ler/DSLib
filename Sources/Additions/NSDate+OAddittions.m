//
//  NSDate+OAddittions.m
//
//  Created by Alexander Belyavskiy on 2/24/12.
//

#import "NSDate+OAddittions.h"
#import "DSDateFormatterCache.h"

//Output means from webservice to the app
#define WEB_SERVICE_OUTPUT_DATE_KEY @"WebServiceOutputDate"
#define WEB_SERVICE_INPUT_DATE_KEY @"WebServiceInputDate"

@implementation NSDate (OAddittions)

+ (NSDate *)currentDate
{
  return [self date];
}

static NSCalendar *gregorianCalendar;

+ (NSCalendar *)gregorianCalendar
{
  if (!gregorianCalendar) {
    gregorianCalendar = [[NSCalendar alloc]
                                     initWithCalendarIdentifier:NSGregorianCalendar];
    [gregorianCalendar setFirstWeekday:2];
  }

  return gregorianCalendar;
}

- (NSDate *)dateByAddingDays:(int)day
{
  // http://stackoverflow.com/questions/1081689/how-can-i-get-next-date-using-nsdate
  // start by retrieving day, weekday, month and year components for yourDate
  NSCalendar *gregorian = [NSDate gregorianCalendar];
  NSDateComponents *todayComponents
      = [gregorian components:(NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit)
                     fromDate:self];
  NSInteger theDay = [todayComponents day];
  NSInteger theMonth = [todayComponents month];
  NSInteger theYear = [todayComponents year];

  // now build a NSDate object for yourDate using these components
  NSDateComponents *components = [[NSDateComponents alloc] init];
  [components setDay:theDay];
  [components setMonth:theMonth];
  [components setYear:theYear];
  NSDate *thisDate = [gregorian dateFromComponents:components];

  // now build a NSDate object for the next day
  NSDateComponents *offsetComponents = [[NSDateComponents alloc] init];
  [offsetComponents setDay:day];
  return [gregorian dateByAddingComponents:offsetComponents toDate:thisDate options:0];
}

- (NSInteger)differenceInDays:(NSDate *)date
{
  NSDateComponents *components = [[NSDate gregorianCalendar]
                                          components:NSDayCalendarUnit
                                            fromDate:self
                                              toDate:date
                                             options:0];
  return [components day];
}

- (NSDate *)dateByDroppingMilliseconds
{
  NSDateComponents *components = [[NSDate gregorianCalendar]
                                          components:NSYearCalendarUnit | NSMonthCalendarUnit
                                              | NSDayCalendarUnit | NSHourCalendarUnit
                                              | NSMinuteCalendarUnit | NSSecondCalendarUnit
                                            fromDate:self];
  return [[NSDate gregorianCalendar] dateFromComponents:components];
}

- (NSDate *)nextDay
{
  return [self dateByAddingDays:1];
}

- (NSDate *)previousDay
{
  return [self dateByAddingDays:-1];
}

+ (NSDate *)dateWithHoursSetTo:(int)hours
{
  return [NSDate currentDateWithHours:hours minutes:0];
}

+ (NSDate *)currentDateWithHours:(NSInteger)hours minutes:(NSInteger)minutes
{
  NSDateComponents *comps = [[NSDateComponents alloc] init];
  [comps setHour:hours];
  [comps setMinute:minutes];
  return [[NSCalendar currentCalendar] dateFromComponents:comps];
}

- (NSDate *)dateWithTimeSetToHours:(NSInteger)hours minutes:(NSInteger)minutes
{
  NSDateComponents *comps = [[NSDate gregorianCalendar]
                                     components:NSDayCalendarUnit
                                                    | NSMonthCalendarUnit
                                                    | NSYearCalendarUnit
                                       fromDate:self];

  [comps setHour:hours];
  [comps setMinute:minutes];
  [comps setSecond:0];
  return [[NSDate gregorianCalendar] dateFromComponents:comps];
}

- (NSDateComponents *)componentsForUnit:(NSCalendarUnit)unit
{
  return [[NSDate gregorianCalendar] components:unit fromDate:self];
}

- (NSInteger)hours
{
  return [[self componentsForUnit:NSHourCalendarUnit] hour];
}

- (NSInteger)minutes
{
  return [[self componentsForUnit:NSMinuteCalendarUnit] minute];
}

- (NSString *)dateString
{
  NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
  [formatter setDateStyle:NSDateFormatterShortStyle];
  return [formatter stringFromDate:self];
}

+ (NSDate *)dateForUnit:(NSCalendarUnit)unit beforeDate:(NSDate *)date
{
  NSDate *result;
  [[NSDate gregorianCalendar] rangeOfUnit:unit
                                startDate:&result
                                 interval:0
                                  forDate:date];
  return result;
}

- (NSDate *)dateAtStartOfWeek
{
  return [NSDate dateForUnit:NSWeekCalendarUnit beforeDate:self];
}

- (NSDate *)dateAtStartOfMonth
{
  return [NSDate dateForUnit:NSMonthCalendarUnit beforeDate:self];
}

- (NSDate *)dateAtStartOfYear
{
  return [NSDate dateForUnit:NSYearCalendarUnit beforeDate:self];
}

- (NSDateComponents *)componentsForUnit:(NSCalendarUnit)unit byAdding:(NSInteger)added
{
  NSDateComponents *components = [[NSDateComponents alloc] init];

  switch (unit) {
    case NSDayCalendarUnit:
      [components setDay:added];
      break;
    case NSWeekCalendarUnit:
      [components setWeek:added];
      break;
    case NSMonthCalendarUnit:
      [components setMonth:added];
      break;
    case NSYearCalendarUnit:
      [components setYear:added];
      break;
    default:
      NSAssert(FALSE, @"Adding to calendar unit %d not supported", unit);
  }

  return components;
}

- (NSDate *)dateByAdding:(NSInteger)added toUnit:(NSCalendarUnit)unit
{
  NSDateComponents *components = [self componentsForUnit:unit
                                                byAdding:added];
  return [[NSDate gregorianCalendar]
                  dateByAddingComponents:components toDate:self options:0];
}

- (NSDate *)dateByAddingOneUnitOf:(NSCalendarUnit)added
{
  return [self dateByAdding:1 toUnit:added];
}

- (NSDate *)dateBySubtractingOneUnitOf:(NSCalendarUnit)subtracted
{
  return [self dateByAdding:-1 toUnit:subtracted];
}

+ (NSDate *)dateFromWebServiceDateString:(NSString *)theDateString
{
//  NSDateFormatter *formatter
//    = [DSDateFormatterCache dateFormatterForKey:WEB_SERVICE_OUTPUT_DATE_KEY];
//
//  //Sample date: 2012-05-03T16:52:32.389142+0000
//  NSString *const date_format = @"yyyy-MM-dd'T'HH:mm:ss.SSSSSSz";
//
//  if (formatter == nil) {
//    formatter = [[NSDateFormatter alloc] init];
//    [formatter setDateFormat:date_format];
//    [DSDateFormatterCache cacheDateFormatter:formatter
//                                      forKey:WEB_SERVICE_OUTPUT_DATE_KEY];
//  }
//
//  NSDate *date = [formatter dateFromString:theDateString];
//
//  NSAssert(date, @"date string: {%@} couldn't be decoded with {%@} date format",
//  theDateString, date_format);
//
//  return date;
  NSTimeInterval unixTime = [theDateString doubleValue];
  return [NSDate dateWithTimeIntervalSince1970:unixTime];
}

- (NSString *)webServiceDateString
{
//  NSDateFormatter *formatter
//  = [DSDateFormatterCache dateFormatterForKey:WEB_SERVICE_INPUT_DATE_KEY];
//
////  NSString *const date_format = @"yyyy-MM-dd'T'HH:mm:ss:SSSSSS";
////  NSString *const date_format = @"yyyy-MM-dd'T'HH:mm:ss";
//  NSString *const date_format = @"yyyy-MM-dd'T'HH:mm:ss.SSSSSSz";
//
//  if (formatter == nil) {
//    formatter = [[NSDateFormatter alloc] init];
//    [formatter setDateFormat:date_format];
//    [DSDateFormatterCache cacheDateFormatter:formatter
//                                      forKey:WEB_SERVICE_INPUT_DATE_KEY];
//  }
//
//  NSString *dateString = [formatter stringFromDate:self];
//
//  NSAssert(dateString, @"Something wrong with date formatters");
//
//  return dateString;
  return [NSString stringWithFormat:@"%f", [self timeIntervalSince1970]];
}

+ (NSDate *)now
{
 return [self date];
}

- (BOOL)onSameDayWithDate:(NSDate *)date
{

  NSDateComponents *myComponents = [[NSDate gregorianCalendar]
                                            components:NSDayCalendarUnit
                                                           | NSMonthCalendarUnit
                                                           | NSYearCalendarUnit
                                              fromDate:self];
  NSDateComponents *otherComponents = [[NSDate gregorianCalendar]
                                               components:NSDayCalendarUnit
                                                              | NSMonthCalendarUnit
                                                              | NSYearCalendarUnit
                                                 fromDate:date];

  return myComponents.day == otherComponents.day && myComponents.month == otherComponents.month
      && myComponents.year == otherComponents.year;
}


@end
