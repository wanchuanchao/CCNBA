//
//  DateTime.m
//  nba
//
//  Created by lanou3g on 16/7/12.
//  Copyright © 2016年 wanccao. All rights reserved.
//

#import "DateTime.h"

@implementation DateTime
//根据date返回固定格式YYYY-MM-dd的字符串
+ (NSString *)dateTimeWithDate:(NSDate *)date{
    NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:@"YYYY-MM-dd"];
    NSString *  locationString=[dateformatter stringFromDate:date];
    return locationString;
}
//根据时间戳返回date
+ (NSDate *)dateWithTimeString:(NSString *)timeStr{
    NSTimeInterval time=[timeStr doubleValue]+28800;//因为时差问题要加8小时 == 28800 sec
    NSDate *detaildate=[NSDate dateWithTimeIntervalSince1970:time];
    NSLog(@"date:%@",[detaildate description]);
    return detaildate;
}
//根据date返回时间戳
+ (NSString *)timeStrWithDate:(NSDate *)date{
    NSString *timeStr = [NSString stringWithFormat:@"%ld",(long)[date timeIntervalSince1970]];
return timeStr;
}
+ (NSString *)weekTimeWithDate:(NSDate *)date{
    NSArray * arrWeek=[NSArray arrayWithObjects:@"周日",@"周一",@"周二",@"周三",@"周四",@"周五",@"周六", nil];
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    NSInteger unitFlags = NSCalendarUnitYear|NSCalendarUnitMonth |NSCalendarUnitDay |NSCalendarUnitWeekday |NSCalendarUnitHour |NSCalendarUnitMinute |NSCalendarUnitSecond;
    comps = [calendar components:unitFlags fromDate:date];
    NSInteger week = [comps weekday];
    NSInteger month = [comps month];
    NSInteger day = [comps day];
    NSString *weekStr = [NSString stringWithFormat:@"%@ %.2ld/%.2ld",arrWeek[week - 1],(long)month,(long)day];
    return weekStr;
}
@end
