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
    self.headTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 60) style:(UITableViewStylePlain)];
    self.headTableView.delegate = self;
    self.headTableView.dataSource = self;
    self.headTableView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:self.headTableView];
    
    UINib *nib = [UINib nibWithNibName:@"CCHeadLineTableViewCell" bundle:[NSBundle mainBundle]];
    [self.headTableView registerNib:nib forCellReuseIdentifier:@"CCHeadLineTableViewCell"];
   
    
    MJRefreshNormalHeader* header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self performSelector:@selector(headRefresh)withObject:nil afterDelay:2.0f];
    }];
    //设置自定义文字，因为默认是英文的
    [header setTitle:@"下拉刷新"forState:MJRefreshStateIdle];
    [header setTitle:@"松开加载更多"forState:MJRefreshStatePulling];
    [header setTitle:@"正在刷新中"forState:MJRefreshStateRefreshing];
    
    self.headTableView.mj_header= header;
    [self.headTableView.mj_header beginRefreshing];
     [self getRequest];
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
    [self getRequest];
}
- (void)footRefresh {
    NSLog(@"上拉，加载数据");
    [self.headTableView.mj_footer endRefreshing];
}


#pragma mark 数据请求

- (void)getRequest {
    NSMutableString *urlStr = [NSMutableString string];
    NSString *url = @"http://sportsnba.qq.com/news/index?appver=1.0.2&appvid=1.0.2&column=banner&deviceId=CA0D1337-38E7-441E-9611-26B9FAAA6272&from=app&guid=CA0D1337-38E7-441E-9611-26B9FAAA6272&height=667&network=WiFi&os=iphone&osvid=9.3.2&width=375";
    [CCNewRequest getDataWithUrl:url par:nil successBlock:^(id data) {
        for (NSDictionary *dic in data[@"data"]) {
            NSString *string = dic[@"id"];
            [urlStr appendFormat:@"%%2c%@",string];
        }
        NSString *string = [urlStr substringFromIndex:3];
        [CCNewRequest getDataWithUrl:[NSString stringWithFormat:@"http://sportsnba.qq.com/news/item?appver=1.0.2&appvid=1.0.2&articleIds=%@&column=banner&deviceId=CA0D1337-38E7-441E-9611-26B9FAAA6272&from=app&guid=CA0D1337-38E7-441E-9611-26B9FAAA6272&height=667&network=WiFi&os=iphone&osvid=9.3.2&width=375",string] par:nil successBlock:^(id data) {
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
                CCNewHeadModel *model = [[CCNewHeadModel alloc] init];
                [model setValuesForKeysWithDictionary:[data[@"data"] valueForKey:string1]];
                [self.dataArr addObject:model];
            }
            [self.headTableView reloadData];
            if ([self.headTableView.mj_header isRefreshing]) {
                [self.headTableView.mj_header endRefreshing];
            }
        } failBlock:^(NSError *err) {
            NSLog(@"line = %d,err = %@",__LINE__,err);
        }];
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
