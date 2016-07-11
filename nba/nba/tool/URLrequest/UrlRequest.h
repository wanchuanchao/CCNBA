//
//  UrlRequest.h
//  nba
//
//  Created by lanou3g on 16/7/11.
//  Copyright © 2016年 wanccao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UrlRequest : NSObject
+ (NSArray *)requestWithUrl:(NSString *)url model:(NSObject *)model;
@end
