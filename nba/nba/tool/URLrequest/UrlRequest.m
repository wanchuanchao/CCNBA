//
//  UrlRequest.m
//  nba
//
//  Created by lanou3g on 16/7/11.
//  Copyright © 2016年 wanccao. All rights reserved.
//

#import "UrlRequest.h"

@implementation UrlRequest
+ (NSArray *)requestWithUrl:(NSString *)url model:(Class)className{
    __block NSMutableArray *arr = [[NSMutableArray alloc] init];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager GET:url parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSMutableArray *userArr = (NSMutableArray *)[className mj_objectArrayWithKeyValuesArray:responseObject];
        arr = userArr;
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
    return arr.mutableCopy;
}
@end
