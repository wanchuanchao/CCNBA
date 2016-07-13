//
//  CCNewRequest.h
//  nba
//
//  Created by lanou3g on 16/7/12.
//  Copyright © 2016年 wanccao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CCNewRequest : NSObject

+ (void)getDataWithUrl:(NSString *)url par:(NSDictionary *)par successBlock:(void (^)(id data))successBlock failBlock:(void (^)(NSError *err))failBlock;

@end
