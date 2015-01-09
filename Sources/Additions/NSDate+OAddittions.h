
@import Foundation;

@interface NSDate (OAddittions)

+ (NSDate *)currentDate;

- (NSDate *)nextDay;

- (NSDate *)previousDay;

+ (NSDate *)dateWithHoursSetTo:(int)hours;

+ (NSDate *)currentDateWithHours:(NSInteger)hours minutes:(NSInteger)minutes;

- (NSDate *)dateWithTimeSetToHours:(NSInteger)hours minutes:(NSInteger)minutes;

- (NSInteger)hours;

- (NSInteger)minutes;

- (NSString *)dateString;

- (NSDate *)dateAtStartOfWeek;

- (NSDate *)dateAtStartOfMonth;

- (NSDate *)dateAtStartOfYear;

- (NSDate *)dateByAddingOneUnitOf:(NSCalendarUnit)added;

- (NSDate *)dateBySubtractingOneUnitOf:(NSCalendarUnit)subtracted;

+ (NSDate *)dateFromWebServiceDateString:(NSString *)theDateString;

- (NSString *)webServiceDateString;

+ (NSDate *)now;

- (BOOL)onSameDayWithDate:(NSDate *)date;

- (NSDate *)dateByAddingDays:(int)day;

- (NSInteger)differenceInDays:(NSDate *)date;

- (NSDate *)dateByDroppingMilliseconds;

@end
