//
//  CCAllTableViewCell.h
//  nba
//
//  Created by lanou3g on 16/7/23.
//  Copyright © 2016年 wanccao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CCEastModel.h"
#import "CCWestModel.h"
@interface CCAllTableViewCell : UITableViewCell
/**  东部model */
@property (nonatomic,strong) CCEastModel *eastModel;
/**  西部model */
@property (nonatomic,strong) CCWestModel *westModel;


@end
