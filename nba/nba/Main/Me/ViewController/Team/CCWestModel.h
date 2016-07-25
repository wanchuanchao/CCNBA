//
//  CCWestModel.h
//  nba
//
//  Created by lanou3g on 16/7/23.
//  Copyright © 2016年 wanccao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CCWestModel : NSObject
/**  名字 */
@property (nonatomic,strong) NSString *fullCnName;
/**  logo */
@property (nonatomic,strong) NSString *logo;
/**  传给下一页的url */
@property (nonatomic,strong) NSString *detailUrl;
@property (nonatomic,strong)NSString *city;
@property (nonatomic,strong)NSString *teamId;
@property (nonatomic,strong)NSString *teamName;
@end
