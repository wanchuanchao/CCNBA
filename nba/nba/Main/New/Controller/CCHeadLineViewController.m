//
//  CCHeadLineViewController.m
//  nba
//
//  Created by lanou3g on 16/7/11.
//  Copyright © 2016年 wanccao. All rights reserved.
//

#import "CCHeadLineViewController.h"
#import "CCHeadLineTableViewCell.h"
#import "CCNewRequest.h"
#import "CCNewHeadModel.h"
#import "CCHeadTwoViewController.h"
#import "MJRefresh.h"

@interface CCHeadLineViewController ()<UITableViewDelegate,UITableViewDataSource>
/**  存放数据的数组 */
@property (nonatomic,strong) NSMutableArray *dataArr;
/**  tableView */
@property (nonatomic,strong) UITableView *headTableView;
@end

@implementation CCHeadLineViewController

// 懒加载
- (NSMutableArray *)dataArr{
    if (!_dataArr) {
        _dataArr = [NSMutableArray array];
    }
    return _dataArr;
}



- (void)viewDidLoad {
    [super viewDidLoad];
    self.headTableView = [[UITableView alloc] initWithFrame:self.view.frame style:(UITableViewStylePlain)];
    self.headTableView.delegate = self;
    self.headTableView.dataSource = self;
    [self.view addSubview:self.headTableView];
    
    UINib *nib = [UINib nibWithNibName:@"CCHeadLineTableViewCell" bundle:[NSBundle mainBundle]];
    [self.headTableView registerNib:nib forCellReuseIdentifier:@"CCHeadLineTableViewCell"];
    [self getRequest];
    
    MJRefreshNormalHeader* header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self performSelector:@selector(headRefresh)withObject:nil afterDelay:2.0f];
    }];
    //设置自定义文字，因为默认是英文的
    [header setTitle:@"下拉刷新"forState:MJRefreshStateIdle];
    [header setTitle:@"松开加载更多"forState:MJRefreshStatePulling];
    [header setTitle:@"正在刷新中"forState:MJRefreshStateRefreshing];
    
    self.headTableView.mj_header= header;
    
    //创建上拉刷新
    MJRefreshBackNormalFooter * foot =[MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        
        [self performSelector:@selector(footRefresh)withObject:nil afterDelay:2.0f];
        
    }];
    self.headTableView.mj_footer= foot;
    
    [foot setTitle:@"上拉刷新"forState:MJRefreshStateIdle];
    [foot setTitle:@"松开加载更多"forState:MJRefreshStatePulling];
    [foot setTitle:@"正在刷新中"forState:MJRefreshStateRefreshing];
    
}

// 上拉刷新下拉加载
- (void)headRefresh {
    NSLog(@"下拉,加载数据");
    [self.headTableView.mj_header endRefreshing];
}
- (void)footRefresh {
    NSLog(@"上拉，加载数据");
    [self.headTableView.mj_footer endRefreshing];
}


#pragma mark 数据请求

- (void)getRequest {
    NSString *url = @"http://sportsnba.qq.com/news/item?appver=1.0.2&appvid=1.0.2&articleIds=20160706005300%2C20160706005298%2C20160705030401%2C20160705024020%2C20160705001023%2C20160704001110%2C20160704030469%2C20160703002492%2C20160703000750%2C20160702020097%2C20160702020110%2C20160702020106%2C20160702020100%2C20160702001600%2C20160702001599%2C20160702001601%2C20160701035241%2C20160701032111%2C20160701025057%2C20160701017726&column=banner&deviceId=CA0D1337-38E7-441E-9611-26B9FAAA6272&from=app&guid=CA0D1337-38E7-441E-9611-26B9FAAA6272&height=667&network=WiFi&os=iphone&osvid=9.3.2&width=375";
    [CCNewRequest getDataWithUrl:url par:nil successBlock:^(id data) {
        for (NSDictionary *dic in [data[@"data"] allValues]) {
            CCNewHeadModel *model = [[CCNewHeadModel alloc] init];
            [model setValuesForKeysWithDictionary:dic];
            [self.dataArr addObject:model];
        }
        if (![self.view.subviews containsObject:self.headTableView]) {
            [self.view addSubview:self.headTableView];
        }
        [self.headTableView reloadData];
        NSLog(@"%@",self.dataArr);
    } failBlock:^(NSError *err) {
         NSLog(@"line = %d,err = %@",__LINE__,err);
    }];
}


#pragma mark tableView代理方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CCHeadLineTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CCHeadLineTableViewCell" forIndexPath:indexPath];
    cell.model = _dataArr[indexPath.row];
    
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 280;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    CCHeadTwoViewController *vc = [CCHeadTwoViewController new];
    vc.url =((CCNewHeadModel *)self.dataArr[indexPath.row]).url;
    [self.navigationController pushViewController:vc animated:YES];
}

@end
