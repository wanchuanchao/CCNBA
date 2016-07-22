//
//  CCHighlightsTableViewController.m
//  nba
//
//  Created by lanou3g on 16/7/13.
//  Copyright © 2016年 wanccao. All rights reserved.
//

#import "CCHighlightsTableViewController.h"
#import "CCNewRequest.h"
@interface CCHighlightsTableViewController ()

@end

@implementation CCHighlightsTableViewController

// 花絮
-(NSString *)myurl{

    NSString *url = @"http://sportsnba.qq.com/news/index?appver=1.1&appvid=1.1&column=highlight&deviceId=CA0D1337-38E7-441E-9611-26B9FAAA6272&from=app&guid=CA0D1337-38E7-441E-9611-26B9FAAA6272&height=667&network=WiFi&os=iphone&osvid=9.3.2&width=375";

    return url;
}

@end
