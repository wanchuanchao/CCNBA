//
//  WCCAVPlayerView.m
//  Movieplayer
//
//  Created by lanou3g on 16/6/14.
//  Copyright © 2016年 wanccao. All rights reserved.
//

#import "WCCAVPlayerView.h"
//#import "UIView+WCCExtension.h"
#import <AVFoundation/AVFoundation.h>

#define WIDTH  [UIScreen mainScreen].bounds.size.width
#define HEIGHT [UIScreen mainScreen].bounds.size.height

/** item播放状态 */
typedef enum  {
    playing,
    stop
}Status;
static CGRect originalFrame;
@interface WCCAVPlayerView()<UIGestureRecognizerDelegate>
@property (weak, nonatomic) IBOutlet UIButton *button;//开始暂停按钮
@property (weak, nonatomic) IBOutlet UIButton *fullScreen;      //全屏按钮
@property (weak, nonatomic) IBOutlet UISlider *timeSlider;  //播放滑竿
@property (weak, nonatomic) IBOutlet UILabel *currentTimeLabel; //当前时间
@property (weak, nonatomic) IBOutlet UILabel * totalTimeLabel;// 总时间
@property (weak, nonatomic) IBOutlet UIProgressView *bufferProgressView; //缓存进度条
@property (weak, nonatomic) IBOutlet UIProgressView *timeProgressView;         //播放进度条
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;  //
@property (weak, nonatomic) IBOutlet UIButton *turnBack;   //全屏返回
@property (weak, nonatomic) IBOutlet UIView *MyView;
@property (strong, nonatomic) UIProgressView *volumeProgress;//音量大小
@property (strong, nonatomic) UIProgressView *lightProgress; //亮度大小
@property (nonatomic,strong)NSTimer *timer;             //定时器
@property (nonatomic,strong)NSTimer *misstimer;         //myView消失的timer
@property (nonatomic,strong)AVPlayer *player;           //播放器
@property (nonatomic,strong)AVPlayerLayer *avplayerlayer;      //layer
@property (nonatomic,strong)AVPlayerItem *item;         //播放器item
@property (nonatomic,assign)Status status;              //播放器状态
@property (nonatomic,strong)UIView *fullView;    //
@property (nonatomic,strong)UIView *aView;    //
@end
@implementation WCCAVPlayerView

/** 单粒 */
static WCCAVPlayerView *view = nil;
+ (instancetype)shareWCCAVPlayerView:(CGRect)frame
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        view = [[NSBundle mainBundle] loadNibNamed:@"WCCAVPlayerView" owner:self options:nil].firstObject;
    });
    view.frame = frame;
    originalFrame = frame;
    [view set];
    return view;
}
- (void)set{
    self.backgroundColor = [UIColor blackColor];
    self.smallScreen = NO;
    self.turnBack.hidden = YES;
    self.timeSlider.continuous = NO;
    self.status = playing;
    // 添加音量控制器
    self.volumeProgress = [[UIProgressView alloc] initWithProgressViewStyle:(UIProgressViewStyleDefault)];
    self.volumeProgress.frame = CGRectMake(self.width/6, self.height/4*3, self.height/2, 2);
    self.volumeProgress.progress = _player.volume;
    self.volumeProgress.layer.anchorPoint = CGPointMake(0, 0);
    self.volumeProgress.transform = CGAffineTransformMakeRotation(-M_PI_2);
    // 添加屏幕亮度控制器
    self.lightProgress = [[UIProgressView alloc] initWithProgressViewStyle:(UIProgressViewStyleDefault)];
    self.lightProgress.frame = CGRectMake(self.width/6*5, self.height/4*3, self.height/2, 2);
    self.lightProgress.progress =[UIScreen mainScreen].brightness;
    self.lightProgress.layer.anchorPoint = CGPointMake(0, 0);
    self.lightProgress.transform = CGAffineTransformMakeRotation(-M_PI_2);
    self.volumeProgress.frame = CGRectMake(self.MyView.width/6, self.MyView.height/4*3, self.MyView.height/2, 2);
    self.lightProgress.frame = CGRectMake(self.MyView.width/6*5, self.MyView.height/4*3, self.MyView.height/2, 2);
    [self addSubview:self.volumeProgress];
    [self addSubview:self.lightProgress];
    [self.volumeProgress setHidden:YES];
    [self.lightProgress setHidden:YES];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deviceOrientationDidChange) name:UIDeviceOrientationDidChangeNotification object:nil];
}
#pragma mark //////////////////////////控件方法////////////////////////////
//全屏按钮1
- (IBAction)fullScreenAction:(UIButton *)sender {
    if (self.fullScreen.isSelected == NO) {
        self.transform = CGAffineTransformIdentity;
        [self setFrame:(CGRectMake(0, 0, HEIGHT, WIDTH))];
        self.avplayerlayer.frame =CGRectMake(0, 0, HEIGHT, WIDTH);
        self.transform = CGAffineTransformMakeRotation(M_PI_2);
        [self layoutSubviews];
        [self.MyView layoutSubviews];
        [self.window addSubview:self];
        self.center = self.window.center;
    }else{
        [self turnback];
    }
    self.fullScreen.selected = !self.fullScreen.isSelected;
    self.turnBack.hidden = !self.turnBack.isHidden;
}
//- (void)deviceOrientationDidChange{
//    if ([self superview]) {
//        UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
//        if (orientation == UIInterfaceOrientationPortrait && self.fullScreen.isSelected == NO) {
//            [self turnback];
//        }else{
//            [self transformRotationWithOrientation:orientation];
//        }
//    }
//}
- (void)transformRotationWithOrientation:(UIInterfaceOrientation)orientation{
    if (orientation == UIInterfaceOrientationPortrait || orientation == UIInterfaceOrientationPortraitUpsideDown) {
        [self setFrame:(CGRectMake(0, 0, HEIGHT, WIDTH))];
        self.avplayerlayer.frame =CGRectMake(0, 0, HEIGHT, WIDTH);
        self.transform = CGAffineTransformMakeRotation(M_PI_2);
    }else{
        [self setFrame:(CGRectMake(0, 0, WIDTH, HEIGHT))];
        self.avplayerlayer.frame = CGRectMake(0, 0, WIDTH, HEIGHT);
    }
    [self layoutSubviews];
    [self.MyView layoutSubviews];
    [self.window addSubview:self];
    self.center = self.window.center;
}
//全屏返回按钮
- (IBAction)turnback {
    self.transform = CGAffineTransformIdentity;
    self.frame = originalFrame;
    self.avplayerlayer.frame = originalFrame;
    [self.aView addSubview:self];
    [self layoutSubviews];
    [self.MyView layoutSubviews];
}
// 开始暂停
- (IBAction)buttonAction {
    [self stopMyViewTimer];
    if (self.status == stop) {
        self.button.selected = NO;
        [self play];
        [self startMyViewTimer];
    }else{
        [self stop];
        self.button.selected = YES;
    }
}
// 快进快退
- (IBAction)timeSliderAction:(UISlider *)sender {
    [self seekToTime:CMTimeMakeWithSeconds(self.timeSlider.value,self.item.currentTime.timescale)];
}
//播放器快进快退方法
- (void)seekToTime:(CMTime)time{
    [self stop];
    if (self.misstimer) {
        [self.misstimer invalidate];
    }
    [self.item seekToTime:time completionHandler:^(BOOL finished) {
        if (finished) {
            [self play];
        }
    }];
}
#pragma mark //////////////////////////接口实现////////////////////////////
-(void)setTitle:(NSString *)title{
    self.titleLabel.text = title;
}
-(void)setUrl:(NSString *)url
{
    if (_item) {
        self.button.selected = NO;
        [_item removeObserver:self forKeyPath:@"status"];
        [_item removeObserver:self forKeyPath:@"loadedTimeRanges"];
        /** 添加播放器 */
        //播放资源
        _item = [AVPlayerItem playerItemWithURL:[NSURL URLWithString:url]];
        //监测播放状态
        [_item addObserver:self forKeyPath:@"status" options:(NSKeyValueObservingOptionNew) context:nil];
        [_item addObserver:self forKeyPath:@"loadedTimeRanges" options:(NSKeyValueObservingOptionNew) context:nil];
        [_player replaceCurrentItemWithPlayerItem:_item];
    }else{
        //播放资源
        _item = [AVPlayerItem playerItemWithURL:[NSURL URLWithString:url]];
        //监测播放状态
        [_item addObserver:self forKeyPath:@"status" options:(NSKeyValueObservingOptionNew) context:nil];
        [_item addObserver:self forKeyPath:@"loadedTimeRanges" options:(NSKeyValueObservingOptionNew) context:nil];
        //播放类
        _player = [AVPlayer playerWithPlayerItem:_item];
        _player.volume = 0.5;  //默认音量
        //播放layer
        self.avplayerlayer = [AVPlayerLayer playerLayerWithPlayer:_player];
        self.avplayerlayer.frame = self.frame;
        self.avplayerlayer.backgroundColor = (__bridge CGColorRef _Nullable)([UIColor redColor]);
        _avplayerlayer.videoGravity = AVLayerVideoGravityResizeAspect;
        [self.layer addSublayer:self.avplayerlayer];
        [self addSubview:self.MyView];
        // 播放结束的通知
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(moviePlayFinished:) name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
    }
    
        [self showMyView:NO];
}
-(void)cancel{
    [self stop];
}
////重写setter
//-(void)setFrame:(CGRect)frame{
//    [super setFrame:frame];
//    self.avplayerlayer.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
//    [self layoutSubviews];
//    [self.MyView layoutSubviews];
//}

//播放器是否在播放 getter
- (BOOL)isplaying{
    if (self.status == playing) {
        return YES;
    }else{
        return NO;
    }
}

-(void)setNewFrame:(CGRect)frame{
    self.frame = frame;
    self.avplayerlayer.frame = frame;
    [self layoutSubviews];
    [self.aView layoutSubviews];
}
#pragma mark //////////////////////////手势方法////////////////////////////


- (IBAction)pan:(UIPanGestureRecognizer *)sender {
    if (self.fullScreen.isSelected == NO) {
        return;
    }
   // double playTime = 0;
    float volumeSlider = 0;
    float brightSlider = 0;
    CGPoint translation = [sender translationInView:sender.view];
    CGPoint point = [sender locationInView:sender.view];
    if (sender.state == UIGestureRecognizerStateEnded) {
        [self.lightProgress setHidden:YES];
        [self.volumeProgress setHidden:YES];
    }
    if (sender.state == UIGestureRecognizerStateChanged) {
        if (fabs(translation.x) > fabs(translation.y)) {
            //        //快进快退
            //        playTime = - translation.x / self.timeSlider.width;
            //        [self showMyView];
            //        CMTime currentTime = self.player.currentItem.currentTime;
            //        CMTime time = CMTimeMakeWithSeconds(currentTime.value + playTime, currentTime.timescale);
            //        [self seekToTime:time];
        }else{
            if (point.x < self.width / 2) {
                if (self.volumeProgress.isHidden) {
                    [self.volumeProgress setHidden:NO];
                }
                //音量调节
                volumeSlider = - translation.y / self.volumeProgress.frame.size.width;
                if (self.volumeProgress.progress + volumeSlider <= 1) {
                    self.volumeProgress.progress = self.volumeProgress.progress + volumeSlider;
                     self.player.volume = self.volumeProgress.progress;
                }
            }else{
                if (self.lightProgress.isHidden) {
                    [self.lightProgress setHidden:NO];
                }
                //亮度调节
                brightSlider = - translation.y / self.lightProgress.frame.size.width;
                if (self.lightProgress.progress + brightSlider <= 1) {
                    self.lightProgress.progress = self.lightProgress.progress + brightSlider;
                    [UIScreen mainScreen].brightness = self.lightProgress.progress;
                }
            }
        }
        //清空移动距离
        [sender setTranslation:CGPointZero inView:sender.view];
    }
    
}
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    if ([NSStringFromClass([touch.view class]) isEqualToString:@"MyTableViewCell"]) {
        return NO;
    }else{
        NSLog(@"%@",touch.view.class);
        return YES;
    }
    
}

// 点击屏幕
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self stopMyViewTimer];
    if (self.button.hidden == NO) {
        [self showMyView:NO];
    }else{
        [self showMyView:YES];
        if (self.status == playing) {
            [self startMyViewTimer];
        }
    }
}
- (void)showMyView:(BOOL)showornot{
    [self.fullScreen setHidden:!showornot];
    [self.totalTimeLabel setHidden:!showornot];
    [self.currentTimeLabel setHidden:!showornot];
    [self.timeSlider setHidden:!showornot];
    [self.button setHidden:!showornot];
    [self.titleLabel setHidden:!showornot];
    [self.bufferProgressView setHidden:showornot];
    [self.timeProgressView setHidden:showornot];
}
- (void)showSmallView:(BOOL)show{
    
}
#pragma mark //////////////////////////通知方法////////////////////////////
- (void)moviePlayFinished:(NSNotification *)notification
{
    [self stop];
    [self.button setBackgroundImage:[UIImage imageNamed:@"start"] forState:(UIControlStateNormal)];
    [self.player seekToTime:CMTimeMake(0, self.item.currentTime.timescale) completionHandler:^(BOOL finished) {
        
    }];
}
#pragma mark //////////////////////////通知监听////////////////////////////

#pragma mark //////////////////////////播放器控制////////////////////////////
- (void)play{  //开始播放
    [self.player play];
    self.status = playing;
    if (self.timer)return;
    //开启定时器
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerAction) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSDefaultRunLoopMode];
}
- (void)timerAction{  //定时器方法
    self.timeSlider.value = CMTimeGetSeconds(self.player.currentItem.currentTime);
    self.timeProgressView.progress = (CMTimeGetSeconds(self.player.currentItem.currentTime) / CMTimeGetSeconds(self.item.duration));
    [self setLabelTimeWithTime:self.timeSlider.value];
}
- (void)setLabelTimeWithTime:(float)time{
    if (time > CMTimeGetSeconds(self.item.duration)) return;
    int minus = time / 60; //分钟
    int seconds = (int)time % 60;// 秒
    int totalMinuts = CMTimeGetSeconds(self.item.duration) / 60;
    int totalSeconds = (int)CMTimeGetSeconds(self.item.duration) % 60;
    self.currentTimeLabel.text = [NSString stringWithFormat:@"%02d:%02d",minus,seconds];
    self.totalTimeLabel.text = [NSString stringWithFormat:@"%02d:%02d",totalMinuts,totalSeconds];
}
- (void)stop  //暂停播放
{
    [self.player pause];
    self.status = stop;
    //销毁定时器
    [self.timer invalidate];
    self.timer = nil;
}
/**
 *      kvo
 *
 *  @param keyPath 监听的属性
 *  @param object  属性属于哪个对象
 *  @param change  变化的值
 *  @param context 上面传递的值
 */
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"status"]) {
        /** 监听status属性变化 */
        NSInteger status = [change[@"new"] integerValue];
        switch (status) {
            case AVPlayerItemStatusReadyToPlay://可以播放了
                [self play];
                // self.item.duration 视频总长度
                //                NSLog(@"===============%f",CMTimeGetSeconds(self.item.duration));
                self.timeSlider.maximumValue = CMTimeGetSeconds(self.item.duration);
                //                self.bufferProgressView.progress =
                NSLog(@"可以播放了");
                self.aView = [self superview];
                break;
            case AVPlayerItemStatusFailed://缓冲失败
                NSLog(@"缓冲失败");
                break;
            case AVPlayerItemStatusUnknown://不知道
                NSLog(@"不知道");
                break;
        }
    } else if([keyPath isEqualToString:@"loadedTimeRanges"]){
        CMTimeRange timeRange = [[[self.player currentItem] loadedTimeRanges].firstObject CMTimeRangeValue];
        // 计算缓冲进度
        NSTimeInterval timeInterval = CMTimeGetSeconds(timeRange.start) + CMTimeGetSeconds(timeRange.duration);
        CGFloat totalDuration = CMTimeGetSeconds(self.item.duration);
        if (timeInterval > totalDuration) return;
        [self.bufferProgressView setProgress:timeInterval / totalDuration animated:YES];
    }else{
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}
#pragma mark //////////////////////////添加MyView,并开启定时器,3秒后移除////////////////////////////
- (void)showMyView{
    [self restartMyViewTimer];
    if (self.button.hidden == YES) {
        [self showMyView:YES];
    }
}
- (void)restartMyViewTimer{
    [self stopMyViewTimer];
    [self startMyViewTimer];
}
- (void)startMyViewTimer //开启定时器,三秒后myView自动消失
{
    self.misstimer = [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(misstimerAction) userInfo:nil repeats:NO];
}
- (void)misstimerAction //定时器执行方法,移除myView,下方添加进度条
{
    [self showMyView:NO];
}
- (void)stopMyViewTimer  //移除定时器
{
    if (self.misstimer) {
        [self.misstimer invalidate];
        self.misstimer = nil;
    }
}


@end
