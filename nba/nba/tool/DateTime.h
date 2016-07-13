//
//  DateTime.h
//  nba
//
//  Created by lanou3g on 16/7/12.
//  Copyright © 2016年 wanccao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DateTime : NSObject
+ (NSString *)dateTimeWithDate:(NSDate *)date;
+ (NSString *)weekTimeWithDate:(NSDate *)date;
@end
