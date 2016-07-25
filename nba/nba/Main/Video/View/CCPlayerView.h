//
//  CCPlayerView.h
//  nba
//
//  Created by lanou3g on 16/7/21.
//  Copyright © 2016年 wanccao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
@protocol CCPlayerViewDelegate <NSObject>

@optional
- (void)fullPlay;
- (void)notFullPlay;

@end


@interface CCPlayerView : UIView

+ (instancetype)shareCCPlayerView:(CGRect)frame;

@property (nonatomic,strong)NSString *url;

@property (nonatomic,weak)id<CCPlayerViewDelegate> delegate;

//音量的slider
@property (nonatomic,strong) UISlider *volumeSlider;

@property (nonatomic, strong) AVPlayerLayer *playerLayer;
@property (nonatomic, strong) AVPlayer *player;

//小view
@property (nonatomic,strong) UIView *littleView;
- (void)pause;
@end
