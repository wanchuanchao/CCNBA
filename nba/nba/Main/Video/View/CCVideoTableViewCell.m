//
//  CCVideoTableViewCell.m
//  nba
//
//  Created by lanou3g on 16/7/13.
//  Copyright © 2016年 wanccao. All rights reserved.
//

#import "CCVideoTableViewCell.h"
#import "CCVideoModel.h"

@interface CCVideoTableViewCell ()
// 标题
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
// 时间
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
// 时长
@property (weak, nonatomic) IBOutlet UILabel *durationLabel;
/** 记录当前的button */
@property (nonatomic, strong) UIButton *selectedButton;

- (IBAction)playButtonAction:(id)sender;

@end

@implementation CCVideoTableViewCell

- (void)awakeFromNib {

}

-(void)setVideoModel:(CCVideoModel *)videoModel{
    _videoModel = videoModel;
    self.titleLabel.text = videoModel.title;
    self.timeLabel.text = videoModel.pub_time;
    self.durationLabel.text = videoModel.duration;
    [self.backgroundImageView sd_setImageWithURL:[NSURL URLWithString:videoModel.imgurl] placeholderImage:[UIImage imageNamed:@"jordon"]];
}



- (IBAction)playButtonAction:(UIButton *)sender {
    self.selectedButton.hidden = NO;
    sender.hidden = YES;
    self.selectedButton = sender;
   
    if ([self.delegate respondsToSelector:@selector(videoTableViewCell:videoModel:)]) {
        [self.delegate videoTableViewCell:self videoModel:self.videoModel];
    }

}
@end
