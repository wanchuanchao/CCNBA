//
//  CCNewHeadModel.h
//  nba
//
//  Created by lanou3g on 16/7/12.
//  Copyright © 2016年 wanccao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CCNewHeadModel : NSObject
/**   */
@property (nonatomic,strong) NSString *url;
/**  title */
@property (nonatomic,strong) NSString *title;
/**  第一页图片 */
@property (nonatomic,strong) NSString *imgurl;
/**  第二页图片 */
@property (nonatomic,strong) NSString *imgurl2;
/**  时间 */
@property (nonatomic,strong) NSString *pub_time;
@end
