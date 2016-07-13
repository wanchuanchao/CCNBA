//
//  CCNewRequest.m
//  nba
//
//  Created by lanou3g on 16/7/12.
//  Copyright © 2016年 wanccao. All rights reserved.
//

#import "CCNewRequest.h"

@implementation CCNewRequest

//GET
+ (void)getDataWithUrl:(NSString *)url par:(NSDictionary *)par successBlock:(void (^)(id data))successBlock failBlock:(void (^)(NSError *err))failBlock{
    //    拼接url
    if (par) {
        __block NSMutableString *str = [NSMutableString string];
        [par enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
            [str appendString:[NSString stringWithFormat:@"%@=%@&",key,obj]];
        }];
        url = [url stringByAppendingString:[str substringToIndex:str.length - 2]];
        
        
        //        汉字的处理
        NSCharacterSet *set = [NSCharacterSet URLQueryAllowedCharacterSet];
        url = [url stringByAddingPercentEncodingWithAllowedCharacters:set];
    }
    
    
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [session dataTaskWithURL:[NSURL URLWithString:url] completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        //        解析
        if (!error && data) {
            NSError *err = nil;
            id requestData = [NSJSONSerialization JSONObjectWithData:data options:(NSJSONReadingAllowFragments) error:&err];
            //            如果解析没有出错并且解出来数据并且成功有效
            if (!error && response && successBlock) {     //返回
                dispatch_async(dispatch_get_main_queue(), ^{
                    successBlock(requestData);
                });
            }else{
                if (failBlock) {          //解析出错
                    NSError *err = [NSError errorWithDomain:@"解析出错" code:1 userInfo:nil];
                    failBlock(err);
                }
            }
        }else{
            if (failBlock) {
                failBlock(error);
            }
        }
        
        
    }];
    [dataTask resume];
    
    
}



@end
