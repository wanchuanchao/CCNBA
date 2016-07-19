//
//  WCCAVPlayerView.h
//  Movieplayer
//
//  Created by lanou3g on 16/6/14.
//  Copyright © 2016年 wanccao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WCCAVPlayerView : UIView
+ (instancetype)shareWCCAVPlayerView:(CGRect)frame;
@property (nonatomic,strong)NSString *url;    //网址
@property (nonatomic,strong)NSString *title;    //
- (void)setNewFrame:(CGRect)frame;
//播放器播放状态
@property (nonatomic,assign,readonly)BOOL isplaying;
//是否是小视频播放
@property (nonatomic,assign)BOOL smallScreen;
//播放
- (void)play;
//暂停
- (void)stop;
@end
