//
//  CCHeadLineTableViewCell.m
//  nba
//
//  Created by lanou3g on 16/7/11.
//  Copyright © 2016年 wanccao. All rights reserved.
//

#import "CCHeadLineTableViewCell.h"
#import "CCNewHeadModel.h"
#import <UIImageView+WebCache.h>
@interface CCHeadLineTableViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *headImageView;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@end



@implementation CCHeadLineTableViewCell

- (void)setModel:(CCNewHeadModel *)model {
    self.titleLabel.text = model.title;
    self.timeLabel.text = model.pub_time;
    [self.headImageView sd_setImageWithURL:[NSURL URLWithString:model.imgurl] placeholderImage:[UIImage imageNamed:@"jordon"]];
}


- (void)awakeFromNib {
    
}



@end
