//
//  MatchTableViewCell.m
//  nba
//
//  Created by lanou3g on 16/7/8.
//  Copyright © 2016年 wanccao. All rights reserved.
//

#import "MatchTableViewCell.h"
#import "MatchModel.h"
@interface MatchTableViewCell ()
@property (weak, nonatomic) IBOutlet UILabel *headtitle;
@property (weak, nonatomic) IBOutlet UIImageView *leftBadge;
@property (weak, nonatomic) IBOutlet UILabel *leftName;
@property (weak, nonatomic) IBOutlet UILabel *leftGoal;
@property (weak, nonatomic) IBOutlet UIImageView *rightBadge;
@property (weak, nonatomic) IBOutlet UILabel *rightGoal;
@property (weak, nonatomic) IBOutlet UILabel *rightName;
@property (weak, nonatomic) IBOutlet UILabel *matchDesc;
@property (weak, nonatomic) IBOutlet UILabel *scorecount;
@property (weak, nonatomic) IBOutlet UILabel *theviduo;
@end
@implementation MatchTableViewCell

- (void)awakeFromNib {
    
}
-(void)setModel:(MatchModel *)model{
    self.headtitle.textColor = [UIColor blackColor];
    if (!model) {
        return;
    }
    if ([model.quarter isEqualToString:@""]) {
        //比赛没开始
        self.headtitle.text = [model.startTime substringWithRange:(NSMakeRange(11, 5))];
        self.leftGoal.text = @"-";
        self.rightGoal.text = @"-";
        self.scorecount.text = @"季后赛对阵";
        self.theviduo.text = @"比赛前瞻";
    }else{
        if (![model.quarter isEqualToString:@"第1节"] &&![model.quarter isEqualToString:@"第2节"] &&![model.quarter isEqualToString:@"第3节"]  && [model.quarterTime isEqualToString:@"00:00"]) {
            //比赛结束
            self.headtitle.text = @"已结束";
            self.scorecount.text = @"计数统计";
            self.theviduo.text = @"精彩视频";
        }else{
            //比赛进行中
            self.headtitle.text = [NSString stringWithFormat:@"直播 %@ %@",model.quarter,model.quarterTime];
            self.headtitle.textColor = [UIColor redColor];
        }
        self.leftGoal.text = model.leftGoal;
        self.rightGoal.text = model.rightGoal;
    }
    SDWebImageManager *manager = [SDWebImageManager sharedManager];
    [self.leftBadge sd_setImageWithURL:[NSURL URLWithString:model.leftBadge] placeholderImage:[UIImage imageNamed:@"1"]];
    [manager downloadImageWithURL:[NSURL URLWithString:model.leftBadge] options:SDWebImageRetryFailed progress:^(NSInteger receivedSize, NSInteger expectedSize) {
        
    } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
        
    }];
    self.leftName.text = model.leftName;
    [self.rightBadge sd_setImageWithURL:[NSURL URLWithString:model.rightBadge] placeholderImage:[UIImage imageNamed:@"1"]];
    [manager downloadImageWithURL:[NSURL URLWithString:model.rightBadge] options:SDWebImageRetryFailed progress:^(NSInteger receivedSize, NSInteger expectedSize) {
        
    } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
        
    }];
    self.rightName.text = model.rightName;
    self.matchDesc.text = model.matchDesc;
    
}
@end
