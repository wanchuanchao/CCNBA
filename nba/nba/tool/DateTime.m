//
//  DateTime.m
//  nba
//
//  Created by lanou3g on 16/7/12.
//  Copyright © 2016年 wanccao. All rights reserved.
//

#import "DateTime.h"

@implementation DateTime
+ (NSString *)dateTimeWithDate:(NSDate *)date{
    NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:@"YYYY-MM-dd"];
    NSString *  locationString=[dateformatter stringFromDate:date];
    return locationString;
}
+ (NSString *)weekTimeWithDate:(NSDate *)date{
    NSArray * arrWeek=[NSArray arrayWithObjects:@"周日",@"周一",@"周二",@"周三",@"周四",@"周五",@"周六", nil];
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    NSInteger unitFlags = NSCalendarUnitYear|NSCalendarUnitMonth |NSCalendarUnitDay |NSCalendarUnitWeekday |NSCalendarUnitHour |NSCalendarUnitMinute |NSCalendarUnitSecond;
    comps = [calendar components:unitFlags fromDate:date];
    NSInteger week = [comps weekday];
    NSInteger year=[comps year];
    NSInteger month = [comps month];
    NSInteger day = [comps day];
    NSString *weekStr = [NSString stringWithFormat:@"%@ %.2ld/%.2ld",arrWeek[week-1],(long)month,(long)day];
    return weekStr;
}
@end
