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
@interface CCVideoTableViewController ()<CCVideoTableViewCellDelegate,UMSocialUIDelegate,UIWebViewDelegate>
/** 所有的视频数据 */
@property (nonatomic,strong) NSMutableArray *videosArray;
@property(nonatomic,strong)CCVideoModel *videoModel;
/** 记录当前indexPath */
@property (nonatomic,assign) NSIndexPath *index;
@property (nonatomic,strong) UIWebView *webView;
@property (nonatomic,strong) NSString *wbUrl;
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
    // 设置边距
    [self setupPadding];
    // 加载数据
    [self setupRefresh];
    
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
    // 数据解析
    [CCNewRequest getDataWithUrl:url par:nil successBlock:^(id data) {
        for (NSDictionary *dic in [data[@"data"] allValues]) {
            CCVideoModel *model = [[CCVideoModel alloc] init];
            [model setValuesForKeysWithDictionary:dic];
            [weakSelf.videosArray addObject:model];
        }
        [weakSelf.tableView reloadData];
        // 让[刷新控件]结束刷新
        [weakSelf.tableView.mj_header endRefreshing];
        NSLog(@"%@",weakSelf.videosArray);
    } failBlock:^(NSError *err) {
        NSLog(@"line = %d,err = %@",__LINE__,err);
        // 让[刷新控件]结束刷新
        [weakSelf.tableView.mj_header endRefreshing];
    }];
    
}
/**
 *  加载更多数据
 */
- (void)loadMoreDataTopics{
    
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.videosArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CCVideoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CCVideoTableViewCell" forIndexPath:indexPath];
    cell.delegate = self;
    cell.videoModel = self.videosArray[indexPath.row];
    // 解决重用
    if (indexPath == self.index) {
        [cell.backgroundImageView addSubview:self.webView];
        cell.playButton.hidden = YES;
    }else {
        if ([cell.backgroundImageView.subviews containsObject:self.webView]) {
            [self.webView removeFromSuperview];
        }
        cell.playButton.hidden = NO;
    }
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 280;
}

-(void)videoTableViewCell:(CCVideoTableViewCell *)cell videoModel:(CCVideoModel *)model{
    
    if (cell.playButton.hidden) {
        // 拿当当前cell的indexPath
        NSIndexPath *indexpath = [self.tableView indexPathForCell:cell];
        self.index = indexpath;
        
        
            UIWebView *wb = [[UIWebView alloc]init];
            wb.delegate = self;
            NSURLRequest *request=[NSURLRequest requestWithURL:[NSURL URLWithString:model.url]];
            [wb loadRequest:request];
        
        self.webView = [[UIWebView alloc]initWithFrame:cell.backgroundImageView.frame];
        [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.wbUrl]]];
        
         self.webView.opaque = NO;
        
        [cell.backgroundImageView addSubview:self.webView];
        [self.tableView reloadData];
    }else{
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
  

    
}
- (void)webViewDidFinishLoad:(UIWebView *)webView{
    
     NSString *url = [webView stringByEvaluatingJavaScriptFromString:@"document.getElementById('tenvideo_video_player_0').src"];
     self.wbUrl = url;
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(nullable NSError *)error{
    
}


@end
