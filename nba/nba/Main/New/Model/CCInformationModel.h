//
//  CCInformationModel.h
//  nba
//
//  Created by lanou3g on 16/7/14.
//  Copyright © 2016年 wanccao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CCInformationModel : NSObject

/**  传给第二页的链接 */
@property (nonatomic,strong) NSString *url;
/**  title */
@property (nonatomic,strong) NSString *title;
/**  第一页图片 */
@property (nonatomic,strong) NSString *imgurl;
/**  第二页图片 */
@property (nonatomic,strong) NSString *imgurl2;
/**  时间 */
@property (nonatomic,strong) NSString *pub_time;
/**  副标题 */
@property (nonatomic,strong) NSString *abstract;

@property (nonatomic, strong)NSArray *images_3;
@end
