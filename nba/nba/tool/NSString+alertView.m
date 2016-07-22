//
//  NSString+alertView.m
//  HuanxinApp
//
//  Created by lanou3g on 16/6/27.
//  Copyright © 2016年 lanou3g. All rights reserved.
//

#import "NSString+alertView.h"
#import <UIKit/UIKit.h>

@implementation NSString (alertView)

// 提示框
+ (void)alterString:(NSString *)msg{
    // 判断当前线程
    if ([NSThread currentThread]) { // 主线程
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:msg delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alert show];
    }else{
        dispatch_async(dispatch_get_main_queue(), ^{
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:msg delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            [alert show];
        });
    }
}

@end
