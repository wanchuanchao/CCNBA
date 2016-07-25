//
//  MatchModel.h
//  nba
//
//  Created by lanou3g on 16/7/8.
//  Copyright © 2016年 wanccao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MatchModel : NSObject

@property (nonatomic,strong)NSString *matchDesc;
@property (nonatomic,strong)NSString *leftName; //左侧队名
@property (nonatomic,strong)NSString *leftGoal; //左得分
@property (nonatomic,strong)NSString *rightName;
@property (nonatomic,strong)NSString *rightGoal;
@property (nonatomic,strong)NSString *leftBadge;
@property (nonatomic,strong)NSString *rightBadge;
@property (nonatomic,strong)NSString *quarter;
@property (nonatomic,strong)NSString *quarterTime;
@property (nonatomic,strong)NSString *startTime;
@property (nonatomic,strong)NSString *mid;
@property (nonatomic,strong)NSArray *tabs;
@end
