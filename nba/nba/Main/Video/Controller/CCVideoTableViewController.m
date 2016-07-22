//
//  CCVideoTableViewController.m
//  nba
//
//  Created by lanou3g on 16/7/14.
//  Copyright © 2016年 wanccao. All rights reserved.
//

#import "CCVideoTableViewController.h"
#import "CCVideoTableViewCell.h"
#import <AFNetworking.h>
#import <MJExtension.h>
#import "CCVideoModel.h"
#import "CCNewRequest.h"
#import "UMSocial.h"


#import "CCPlayerView.h"
#import "CCFullViewController.h"
@interface CCVideoTableViewController ()<CCVideoTableViewCellDelegate,UMSocialUIDelegate,UIWebViewDelegate,CCPlayerViewDelegate>
/** 所有的视频数据 */
@property (nonatomic,strong) NSMutableArray *videosArray;
@property(nonatomic,strong)CCVideoModel *videoModel;
@property (nonatomic,strong)CCPlayerView *playerView;
/** 记录当前indexPath */
@property (nonatomic,assign) NSIndexPath *index;
@property (nonatomic,strong) UIWebView *webView;

/** 保存视频类型 */
@property (nonatomic,strong) NSString *columen;
@property (nonatomic,strong)CCVideoTableViewCell *currentCell;

@property (assign, nonatomic) BOOL cellShouldShow;
@property (assign, nonatomic) BOOL isOnCell;
@property (assign, nonatomic) BOOL isOnWindow;
@property (assign, nonatomic) BOOL isPlaying;
@end

@implementation CCVideoTableViewController
// 为了消除编译器发出的警告 : type方法没有实现
-(NSString *)myurl{
    return nil;
}
// 懒加载
-(NSMutableArray *)videosArray{
    if (!_videosArray) {
        _videosArray = [NSMutableArray array];
    }
    return _videosArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.isPlaying = NO;
    self.cellShouldShow = NO;
    self.isOnCell = NO;
    self.isOnWindow = NO;
    
    // 设置边距
    [self setupPadding];
    // 加载数据
    [self setupRefresh];

}
- (void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBarHidden = NO;
    self.isOnCell = NO;
    self.playerView.delegate = self;
    self.currentCell.hidden = NO;
    if (self.isOnWindow) {
        self.isOnWindow = NO;
        [self putToWindow];
    }else{
        self.isOnCell = NO;
        [self backToCell];
    }
    
}

- (void)dealloc{
    if (self.playerView) {
        [self.playerView.player pause];
        [self.playerView removeFromSuperview];
        self.isPlaying = NO;
    }
}

#pragma mark-------- 内部方法----------
- (void)putToWindow
{
    if (!self.isOnWindow) {
        
        [self.playerView removeFromSuperview];
        [UIView animateWithDuration:0.5 animations:^{
            self.playerView.frame = CGRectMake(0,self.view.frame.size.height-49 -(300/16*9),(WIDTH/3) * 2,300/16*9);
            [[UIApplication sharedApplication].keyWindow addSubview:self.playerView];
            self.isOnWindow = YES;
            self.isOnCell = NO;
            //self.playerView.littleView.hidden = YES;
        } completion:^(BOOL finished) {
        }];
    }
}

- (void)backToCell
{
    if (!self.isOnCell) {
        [self.playerView removeFromSuperview];
        
        [UIView animateWithDuration:0.5f animations:^{
            
            [self.currentCell.contentView addSubview:self.playerView];
            
            self.playerView.frame = self.currentCell.backgroundImageView.frame;
            
            self.isOnCell = YES;
            self.isOnWindow = NO;
            
        }completion:^(BOOL finished) {
            
        }];
        
    }
}


/**
 *  设置内边距
 */
-(void)setupPadding{
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.contentInset = UIEdgeInsetsMake(35, 0, 64, 0);
    self.tableView.scrollIndicatorInsets = self.tableView.contentInset;
    // 注册cell
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([CCVideoTableViewCell class]) bundle:nil] forCellReuseIdentifier:@"CCVideoTableViewCell"];
}

/**
 *  添加刷新数据控件
 */
-(void)setupRefresh{
    // 下拉刷新控件
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadDataTopics)];
    // 自动改变透明度
    self.tableView.mj_header.automaticallyChangeAlpha = YES;
    // 进入就开始刷新
    [self.tableView.mj_header beginRefreshing];
    // 上拉刷新控件
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreDataTopics)];
}

/**
 *  加载数据
 */
-(void)loadDataTopics{
    NSString *url = self.myurl;
    __weak typeof(self) weakSelf = self;
    NSMutableString *urlStr = [NSMutableString string];
    [CCNewRequest getDataWithUrl:url par:nil successBlock:^(id data) {
        for (NSDictionary *dic in data[@"data"]) {
            NSString *string = dic[@"id"];
            weakSelf.columen = dic[@"column"];
            [urlStr appendFormat:@"%%2C%@",string];
        }
        NSString *string = [urlStr substringFromIndex:3];
        [CCNewRequest getDataWithUrl:[NSString stringWithFormat:@"http://sportsnba.qq.com/news/item?appver=1.0.2&appvid=1.0.2&articleIds=%@&column=%@&deviceId=CA0D1337-38E7-441E-9611-26B9FAAA6272&from=app&guid=CA0D1337-38E7-441E-9611-26B9FAAA6272&height=667&network=WiFi&os=iphone&osvid=9.3.2&width=375",string,weakSelf.columen] par:nil successBlock:^(id data) {
            NSArray *arr = [data[@"data"] allKeys];
            NSComparator cmptr = ^(id obj1, id obj2){
                if ([obj1 integerValue] < [obj2 integerValue]) {
                    return (NSComparisonResult)NSOrderedDescending;
                }
                if ([obj1 integerValue] > [obj2 integerValue]) {
                    return (NSComparisonResult)NSOrderedAscending;
                }
                return (NSComparisonResult)NSOrderedSame;
            };
            
            for (NSString *string1 in (NSArray *)[arr sortedArrayUsingComparator:cmptr]) {
                CCVideoModel *model = [[CCVideoModel alloc] init];
                [model setValuesForKeysWithDictionary:[data[@"data"] valueForKey:string1]];
                [weakSelf.videosArray addObject:model];
            }
            [weakSelf.tableView reloadData];
            [weakSelf.tableView.mj_header endRefreshing];

        } failBlock:^(NSError *err) {
            NSLog(@"line = %d,err = %@",__LINE__,err);
            [weakSelf.tableView.mj_header endRefreshing];
        }];
    } failBlock:^(NSError *err) {
        NSLog(@"line = %d,err = %@",__LINE__,err);
    }];

    
}
/**
 *  加载更多数据
 */
- (void)loadMoreDataTopics{
    
}


//滚动时自动调用
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (self.playerView == nil) {
        return;
    }
    //如果划出去了，我们就缩小放到右下角
    CGRect currentCellRect = [self.tableView convertRect:self.currentCell.frame toView:self.view];
    if (currentCellRect.origin.y < -self.currentCell.frame.size.height + 64 || currentCellRect.origin.y > self.view.bounds.size.height) {
        //放到windows上
        [self putToWindow];
    }
    else {
        //如果划进来了的话，我们继续放到cell上播放
        if (self.cellShouldShow) {
            [self backToCell];
        }
    }
}


#pragma mark - Tableview data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.videosArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CCVideoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CCVideoTableViewCell" forIndexPath:indexPath];
    cell.delegate = self;
    cell.videoModel = self.videosArray[indexPath.row];
    // 解决重用
    if (indexPath == self.index) {
        [cell.backgroundImageView addSubview:self.playerView];
        self.playerView.frame = self.currentCell.backgroundImageView.frame;
        cell.playButton.hidden = YES;
    }else {
        if ([cell.backgroundImageView.subviews containsObject:self.playerView]) {
            [self.playerView removeFromSuperview];
        }
        cell.playButton.hidden = NO;
    }
    
    NSArray *visibleIndexpaths = [self.tableView indexPathsForVisibleRows];
    
    if ([visibleIndexpaths containsObject:self.index]) {
        self.cellShouldShow = YES;
    }
    else {
        self.cellShouldShow = NO;
    }

    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 280;
}

#pragma mark -- CCPlayerViewDelegate
- (void)fullPlay{
    CCFullViewController *full = [[CCFullViewController alloc] init];
    full.playerView = self.playerView;
    full.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:full animated:YES];
}
#pragma mark -- CCVideoTableViewCellDelegate
-(void)playVideoTableViewCell:(CCVideoTableViewCell *)cell videoModel:(CCVideoModel *)model{
    
        // 拿当当前cell的indexPath
        NSIndexPath *indexpath = [self.tableView indexPathForCell:cell];
        if (indexpath != self.index ){
            [self.playerView removeFromSuperview];
            self.currentCell = cell;
            self.index = indexpath;
            [self backToCell];
            
        }
        self.currentCell = cell;
        self.index = indexpath;
        
        self.webView = [[UIWebView alloc]init];
        [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:model.url]]];
        self.webView.delegate = self;
 
    
  
}
// 分享
-(void)shareVideoTableViewCell:(CCVideoTableViewCell *)cell videoModel:(CCVideoModel *)model{
    //如果需要分享回调，请将delegate对象设置self，并实现下面的回调方法
    [UMSocialData defaultData].extConfig.title = model.title;
    [UMSocialData defaultData].extConfig.qqData.url = @"http://baidu.com";
    [UMSocialSnsService presentSnsIconSheetView:self
                                         appKey:@"5788e997e0f55aab37001bfc"
                                      shareText:model.url
                                     shareImage:cell.backgroundImageView
                                shareToSnsNames:@[UMShareToWechatSession,UMShareToWechatTimeline,UMShareToSina,UMShareToQQ,UMShareToQzone]
                                       delegate:self];
}
#pragma mark ---webView delegate



- (void)webViewDidFinishLoad:(UIWebView *)webView{
    
    if (webView.isLoading) {
        return;
    }

    NSString *url = [webView stringByEvaluatingJavaScriptFromString:@"document.getElementById('tenvideo_video_player_0').src"];
    CCVideoTableViewCell *cell = [[CCVideoTableViewCell alloc]init];
    self.playerView = [CCPlayerView shareCCPlayerView:cell.backgroundImageView.frame];
    self.playerView.delegate = self;
    self.playerView.url = url;
    [cell.backgroundImageView addSubview:self.playerView];
    [self.tableView reloadData];
    NSLog(@"%@",url);

}



@end
