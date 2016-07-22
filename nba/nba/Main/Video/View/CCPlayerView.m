//
//  CCPlayerView.m
//  nba
//
//  Created by lanou3g on 16/7/21.
//  Copyright © 2016年 wanccao. All rights reserved.
//

#import "CCPlayerView.h"
#import <AVFoundation/AVFoundation.h>
#import "CCVideoTableViewController.h"

static CCPlayerView *view = nil;

typedef NS_ENUM(NSInteger,playerStatus){
    playing,
    pauseed
};
@interface CCPlayerView ()<NSURLSessionDownloadDelegate>

//播放状态
@property (nonatomic,assign) playerStatus status;
//定时器
@property (nonatomic,strong) NSTimer *timer;
//资源文件
@property (nonatomic,strong) AVPlayerItem *item;
//大播放键
@property (nonatomic,strong) UIButton *bigPlayButton;
//progressview
@property (nonatomic,strong) UIProgressView *bufferProgressView;
//进度条
@property (nonatomic,strong) UISlider *timeSlider;
//tiemelabel
@property (nonatomic,strong) UILabel *timeLabel;
//播放暂停键
@property (nonatomic,strong) UIButton * playButton;
//音量键
@property (nonatomic,strong) UIButton * speakerButton;
//下载键
@property (nonatomic,strong) UIButton *downloadButton;

//全屏键
@property (nonatomic,strong) UIButton *fullButton;
@property (nonatomic,assign) BOOL isfull;

@property (nonatomic,strong) NSURLSession *session;
@property (nonatomic,strong) NSURLSessionDownloadTask *task;
@property (nonatomic,strong)NSData *data;


@end

@implementation CCPlayerView

#define WIDTH self.frame.size.width
#define HEIGHT self.frame.size.height

+ (instancetype)shareCCPlayerView:(CGRect)frame{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        view = [[CCPlayerView alloc] initWithFrame:frame];
    });
    return view;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        self.player = [[AVPlayer alloc] init];
        self.playerLayer = [AVPlayerLayer playerLayerWithPlayer:self.player];
        self.playerLayer.frame =self.bounds;
        [self.layer addSublayer:self.playerLayer];
        self.backgroundColor = [UIColor blackColor];
        self.littleView = [[UIView alloc] initWithFrame:CGRectMake(0, HEIGHT - 40, WIDTH, 40)];
        self.littleView.backgroundColor = [UIColor grayColor];
        [self addSubview:self.littleView];
        self.littleView.hidden = YES;
        
        //大播放键
        self.bigPlayButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
        self.bigPlayButton.frame = CGRectMake(0, 0, 60, 60);
        [self.bigPlayButton setBackgroundImage:[UIImage imageNamed:@"播放 (4)"] forState:(UIControlStateNormal)];
        self.bigPlayButton.center = self.center;
        
        [self addSubview:self.bigPlayButton];
        [self.bigPlayButton addTarget:self action:@selector(bigPlayButtonAction:) forControlEvents:(UIControlEventTouchUpInside)];
        
        //播放暂停键
        self.playButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
        [self.playButton setBackgroundImage:[UIImage imageNamed:@"播放 (2)"] forState:(UIControlStateNormal)];
        [self.littleView addSubview:self.playButton];
        [self.playButton addTarget:self action:@selector(bigPlayButtonAction:) forControlEvents:(UIControlEventTouchUpInside)];
        self.playButton.frame = CGRectMake(10, 10, 20, 20);
        
        //全屏键
        self.fullButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
        [self.fullButton setBackgroundImage:[UIImage imageNamed:@"全屏"] forState:(UIControlStateNormal)];
        [self.littleView addSubview:self.fullButton];
        [self.fullButton addTarget:self action:@selector(fullButtonAction) forControlEvents:(UIControlEventTouchUpInside)];
        self.fullButton.frame = CGRectMake(WIDTH-40, 10, 20, 20);
        self.isfull = NO;
        
        //喇叭键
        self.speakerButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
        [self.speakerButton setBackgroundImage:[UIImage imageNamed:@"喇叭"] forState:(UIControlStateNormal)];
        [self.littleView addSubview:self.speakerButton];
        [self.speakerButton addTarget:self action:@selector(speakerButtonAction) forControlEvents:(UIControlEventTouchUpInside)];
        self.speakerButton.frame = CGRectMake(WIDTH-70, 10, 20, 20);
        
        //下载键
        self.downloadButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
        [self.downloadButton setBackgroundImage:[UIImage imageNamed:@"下载"] forState:(UIControlStateNormal)];
        [self.littleView addSubview:self.downloadButton];
        [self.downloadButton addTarget:self action:@selector(downloadAction:) forControlEvents:(UIControlEventTouchUpInside)];
        self.downloadButton.frame = CGRectMake(WIDTH-100, self.littleView.frame.size.height - 30, 20, 20);
        
        
        //tiemelabel
        self.timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(WIDTH-200, self.littleView.frame.size.height - 40, 130, 40)];
        self.timeLabel.font = [UIFont systemFontOfSize:13];
        [self.littleView addSubview:self.timeLabel];
        
        //progressview
        self.bufferProgressView = [[UIProgressView alloc ]initWithProgressViewStyle:(UIProgressViewStyleDefault)];
        self.bufferProgressView.frame = CGRectMake(40, 20, WIDTH-280, 40);
        [self.littleView addSubview:self.bufferProgressView];
        self.bufferProgressView.tintColor = [UIColor grayColor];
        
        //进度条
        self.timeSlider = [[UISlider alloc] initWithFrame:CGRectMake(40, 0, WIDTH-280, 40)];
        self.timeSlider.maximumTrackTintColor = [UIColor clearColor];
        self.timeSlider.minimumTrackTintColor = [UIColor greenColor];
        [self.littleView addSubview:self.timeSlider];
        self.timeSlider.value = 0;
        [self.timeSlider addTarget:self action:@selector(timeSliderAction) forControlEvents:(UIControlEventValueChanged)];
        [self.timeSlider setThumbImage:[UIImage imageNamed:@"thumbImage"] forState:(UIControlStateNormal)];
        
        //添加音量的slider
        self.volumeSlider = [[UISlider alloc] initWithFrame:CGRectMake(WIDTH-60,HEIGHT-180 , 100, 100)];
        self.volumeSlider.maximumValue = 1;
        self.volumeSlider.minimumValue = 0;
        self.volumeSlider.value = self.player.volume;
        [self.volumeSlider addTarget:self action:@selector(volumeSliderChange:) forControlEvents:(UIControlEventValueChanged)];
        [self addSubview:self.volumeSlider];
        self.volumeSlider.layer.anchorPoint = CGPointMake(0.5, 1);
        self.volumeSlider.transform = CGAffineTransformMakeRotation(M_PI*3/2);
        self.volumeSlider.hidden = YES;
        [self.volumeSlider setThumbImage:[UIImage imageNamed:@"thumbImage"] forState:(UIControlStateNormal)];
        
        //播放结束的通知
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(moviePlayFinshed:) name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
        
    }
    return self;
}

- (void)layoutSubviews{
    
    self.playerLayer.frame = self.bounds;
    self.littleView.frame = CGRectMake(0, self.frame.size.height - 40, self.frame.size.width, 40);
    
    self.bigPlayButton.center = self.center;
    self.playButton.frame = CGRectMake(10, 10, 20, 20);
    self.speakerButton.frame = CGRectMake(WIDTH-70, 10, 20, 20);
    self.downloadButton.frame = CGRectMake(WIDTH-100, self.littleView.frame.size.height - 30, 20, 20);
    self.timeLabel.frame = CGRectMake(WIDTH-200, self.littleView.frame.size.height - 40, 130, 40);
    self.bufferProgressView.frame = CGRectMake(40, 20, WIDTH-250, 40);
    self.timeSlider.frame = CGRectMake(40, 0, WIDTH-250, 40);
    self.volumeSlider.frame = CGRectMake(WIDTH-60,HEIGHT-180 , 100, 100);
    self.fullButton.frame = CGRectMake(WIDTH-40, 10, 20, 20);
}




- (void)speakerButtonAction{
    self.volumeSlider.hidden = !self.volumeSlider.hidden;
}


- (void)fullButtonAction{
    
    self.isfull = !self.isfull;
    if (self.isfull) {
        [self.fullButton setBackgroundImage:[UIImage imageNamed:@"退出全屏"] forState:(UIControlStateNormal)];
        if ([self.delegate respondsToSelector:@selector(fullPlay)]) {
            [self.delegate fullPlay];
        }

    } else {
        [self.fullButton setBackgroundImage:[UIImage imageNamed:@"全屏"] forState:(UIControlStateNormal)];
        if ([self.delegate respondsToSelector:@selector(notFullPlay)]) {
            [self.delegate notFullPlay];
        }
    }
}


//播放结束的通知
- (void)moviePlayFinshed:(NSNotification *)notification{
    //暂停一下
    self.bigPlayButton.hidden = NO;
    [self pause];
   
}

//点击事件
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    self.littleView.hidden = !self.littleView.hidden;
    if (self.littleView.hidden) {
        self.volumeSlider.hidden = YES;
    }
}

//url  set 方法
- (void)setUrl: (NSString *)url {
    
    self.bigPlayButton.hidden = YES;
    
    //取消监听
    if (self.item) {
        [self.item removeObserver:self forKeyPath:@"status"];
        [self.item removeObserver:self forKeyPath:@"loadedTimeRanges"];
    }
    
    self.item = [AVPlayerItem playerItemWithURL:[NSURL URLWithString:url]];
    
    [self.item addObserver:self forKeyPath:@"status" options:(NSKeyValueObservingOptionNew) context:nil];
    [self.item addObserver:self forKeyPath:@"loadedTimeRanges" options:(NSKeyValueObservingOptionNew) context:nil];
    [self.player replaceCurrentItemWithPlayerItem:self.item];
    
}

// 属性监听
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context{
    if ([keyPath isEqualToString:@"status"]) {  //status变化
        
        NSInteger status = [change[@"new"] integerValue];
        switch (status) {
            case AVPlayerItemStatusReadyToPlay: //可以播放了
                NSLog(@"可以播放了");
                //播放
                [self play];
                //获取到视频的总长度
                //设置滑杆的最大值
                self.timeSlider.maximumValue = CMTimeGetSeconds(self.item.duration);
                break;
            case AVPlayerItemStatusFailed:      //缓冲失败
                NSLog(@"失败");
                break;
            case AVPlayerItemStatusUnknown:     //不知道当前状态
                NSLog(@"不知道当前状态");
                break;
            default:
                NSLog(@"都不符合");
                break;
        }
    } else if ([keyPath isEqualToString:@"loadedTimeRanges"]) {
        //缓冲条
        NSArray *arr = change[@"new"];
        CMTimeRange rang = [arr.lastObject CMTimeRangeValue];
        //获取一下开始的时间
        //当前缓冲的时间
        float time = CMTimeGetSeconds(rang.start) + CMTimeGetSeconds(rang.duration);
        float progressValue = time / CMTimeGetSeconds(self.item.duration);
        self.bufferProgressView.progress = progressValue;
        
        
    }
}

//快进
- (void)timeSliderAction{
    [self pause];
    /**   第几秒   速率*/
    [self.player seekToTime:CMTimeMakeWithSeconds(self.timeSlider.value, self.item.currentTime.timescale) completionHandler:^(BOOL finished) {
        if (finished) { //设置到当前时间
            [self play];
        }
    }];
}

//播放暂停
- (void)bigPlayButtonAction:(UIButton *)sender{
    if (sender == self.bigPlayButton) {
        [self play];
    } else {
        self.bigPlayButton.hidden = NO;
        if (self.status == playing) {
            [self pause];
        }else {
            [self play];
        }
    }
}

//音量
- (void)volumeSliderChange:(UISlider *)slider{
    self.player.volume = slider.value;
}


//定时器
- (void)timerAction{
    self.timeSlider.value = CMTimeGetSeconds(self.item.currentTime);
    [self setLabelTimeWithTime:self.timeSlider.value];
}

//播放
- (void)play {
    [self.player play];
    self.status = playing;
    [self.playButton setBackgroundImage:[UIImage imageNamed:@"播放 (3)"] forState:(UIControlStateNormal)];
    self.bigPlayButton.hidden = YES;
    if (self.timer) {
        return;
    }
    //开启定时器
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerAction) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSDefaultRunLoopMode];
    
}
//暂停
- (void)pause{
    [self.player pause];
    self.status = pauseed;
    [self.playButton setBackgroundImage:[UIImage imageNamed:@"播放 (2)"] forState:(UIControlStateNormal)];
    //销毁定时器
    [self.timer invalidate];
    self.timer = nil;
}

- (void)setLabelTimeWithTime:(float)time {
    int minuts = time / 60; //分钟
    int secondes = (int)time % 60; //秒
    int totalMinuts = CMTimeGetSeconds(self.item.duration) / 60;  //总分钟数
    int totalSecondes = (int)CMTimeGetSeconds(self.item.duration) % 60;  //总时间的秒数
    NSString *str = [NSString stringWithFormat:@"%.2d:%.2d / %.2d:%.2d",minuts,secondes,totalMinuts,totalSecondes];
    self.timeLabel.text = str;
}

- (NSURLSession *)session{
    if (!_session) {
        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
        _session = [NSURLSession sessionWithConfiguration:configuration delegate:self delegateQueue:[NSOperationQueue mainQueue]];
    }
    return _session;
}

//开始下载,暂停,恢复下载
- (void)downloadAction:(UIButton *)sender {
    
    if (sender.selected) {
        [sender setTitle:@"恢复" forState:(UIControlStateNormal)];
        //暂停
        [self.task cancelByProducingResumeData:^(NSData * _Nullable resumeData) {
            self.data = resumeData;
        }];
        self.task = nil;
    }else{
        
        if (self.data) {
            //恢复下载
            self.task = [self.session downloadTaskWithResumeData:self.data];
            [self.task resume];
        }else {
            
            //开始下载 (恢复)
            //任务,(默认挂起)
            CCVideoTableViewController *VC = [[CCVideoTableViewController alloc]init];
            self.task = [self.session downloadTaskWithRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:VC.wbUrl]]];
            //开启任务
            [self.task resume];
        }
        //开始下载
        [sender setTitle:@"暂停" forState:(UIControlStateNormal)];
        
    }
    sender.selected = !sender.selected;
}

//下载完成
- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask
didFinishDownloadingToURL:(NSURL *)location{
    NSLog(@"下载完成%@",location);
    //获取document
    [self.downloadButton setTitle:@"完成" forState:(UIControlStateNormal)];
    NSString *document = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).lastObject;
    NSString *moviePath = [document stringByAppendingPathComponent:@"视频.mp4"];
    //创建文件管理类
    NSFileManager *mgr = [NSFileManager defaultManager];
    //移动
    [mgr moveItemAtURL:location toURL:[NSURL fileURLWithPath:moviePath] error:nil];
    NSLog(@"%@",moviePath);
    //    NSLog(@"当前线程=%@",[NSThread currentThread]);
}

- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didResumeAtOffset:(int64_t)fileOffset expectedTotalBytes:(int64_t)expectedTotalBytes{
    
}

//暂停  2.任务(同时可以下载3个)  3,这次请求到多少数据 4.已经请求下来数据的长度  5.这个数据一共有多长
- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didWriteData:(int64_t)bytesWritten totalBytesWritten:(int64_t)totalBytesWritten totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite{
    //    //已经下载的百分比
    //    CGFloat volue = totalBytesWritten * 1.0 / totalBytesExpectedToWrite;
    //    //设置progressView
    //    self.progressView.progress = volue;
    //    self.valueLable.text = [NSString stringWithFormat:@"%0.2f%%",volue * 100];
}

@end
