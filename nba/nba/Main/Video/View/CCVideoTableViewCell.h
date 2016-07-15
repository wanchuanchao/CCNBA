//
//  CCVideoTableViewCell.h
//  nba
//
//  Created by lanou3g on 16/7/13.
//  Copyright © 2016年 wanccao. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CCVideoModel;
@class CCVideoTableViewCell;
@protocol CCVideoTableViewCellDelegate <NSObject>

-(void)videoTableViewCell:(CCVideoTableViewCell *)cell videoModel:(CCVideoModel *)model;

@end

@interface CCVideoTableViewCell : UITableViewCell
/** 视频模型数据 */
@property (nonatomic,strong) CCVideoModel *videoModel;
@property (nonatomic,weak)id<CCVideoTableViewCellDelegate>delegate;
@property (weak, nonatomic) IBOutlet UIButton *playButton;
//背景图片
@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView;
@end
