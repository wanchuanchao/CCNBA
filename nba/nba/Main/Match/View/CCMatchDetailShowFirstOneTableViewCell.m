//
//  CCMatchDetailShowFirstOneTableViewCell.m
//  nba
//
//  Created by lanou3g on 16/7/24.
//  Copyright © 2016年 wanccao. All rights reserved.
//

#import "CCMatchDetailShowFirstOneTableViewCell.h"

@interface CCMatchDetailShowFirstOneTableViewCell ()
@property (weak, nonatomic) IBOutlet UIImageView *teamone;
@property (weak, nonatomic) IBOutlet UIImageView *teamtwo;
@end
@implementation CCMatchDetailShowFirstOneTableViewCell

- (void)awakeFromNib {
    
}

-(void)setDataDic:(NSDictionary *)dataDic{
    _dataDic = dataDic;
    [self.teamone sd_setImageWithURL:[NSURL URLWithString:dataDic[@"teamInfo"][@"leftBadge"]] placeholderImage:[UIImage imageNamed:@"back"]];
    [self.teamtwo sd_setImageWithURL:[NSURL URLWithString:dataDic[@"teamInfo"][@"rightBadge"]] placeholderImage:[UIImage imageNamed:@"back"]];
}
@end
