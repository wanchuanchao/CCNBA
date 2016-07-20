//
//  CCCalendarCollectionViewCell.h
//  nba
//
//  Created by lanou3g on 16/7/19.
//  Copyright © 2016年 wanccao. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CCCalendarModel;
@interface CCCalendarCollectionViewCell : UICollectionViewCell
@property (nonatomic , strong) UILabel *dateLabel;
@property (nonatomic,strong)CCCalendarModel *model;
@end
