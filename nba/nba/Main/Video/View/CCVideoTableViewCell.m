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
    self.backgroundImageView.userInteractionEnabled = YES;
}


// 播放点击事件
- (IBAction)playButtonAction:(UIButton *)sender {
    self.selectedButton.hidden = NO;
    sender.hidden = YES;
    self.selectedButton = sender;
   
    if ([self.delegate respondsToSelector:@selector(videoTableViewCell:videoModel:)]) {
        [self.delegate videoTableViewCell:self videoModel:self.videoModel];
    }

}
// 分享点击事件
- (IBAction)shareButtonAction:(UIButton *)sender {
    
    if ([self.delegate respondsToSelector:@selector(videoTableViewCell:videoModel:)]) {
        [self.delegate videoTableViewCell:self videoModel:self.videoModel];
    }
}
@end
