//
//  CCInformationTableViewCell.m
//  nba
//
//  Created by lanou3g on 16/7/13.
//  Copyright © 2016年 wanccao. All rights reserved.
//

#import "CCInformationTableViewCell.h"
#import "CCInformationModel.h"
@interface CCInformationTableViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *informationImage;

@property (weak, nonatomic) IBOutlet UILabel *titleLable;

@property (weak, nonatomic) IBOutlet UILabel *detailLabel;

@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@end



@implementation CCInformationTableViewCell

- (void)setModel:(CCInformationModel *)model {
    self.titleLable.text = model.title;
    self.timeLabel.text = model.pub_time;
    self.detailLabel.text = model.abstract;
    [self.informationImage sd_setImageWithURL:[NSURL URLWithString:model.imgurl] placeholderImage:[UIImage imageNamed:@"jordon"]];
}


- (void)awakeFromNib {
    
    
}



@end
