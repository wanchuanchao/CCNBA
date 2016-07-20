//
//  CCVideoModel.h
//  nba
//
//  Created by lanou3g on 16/7/13.
//  Copyright © 2016年 wanccao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CCVideoModel : NSObject
/** url */
@property (nonatomic,strong) NSString *url;
/** title */
@property (nonatomic,strong) NSString *title;
/** 小图片 */
@property (nonatomic,strong) NSString *imgurl;
/** 大图片 */
@property (nonatomic,strong) NSString *imgurl2;
/** 时间 */
@property (nonatomic,strong) NSString *pub_time;
/** 时长 */
@property (nonatomic,strong) NSString *duration;

@end
