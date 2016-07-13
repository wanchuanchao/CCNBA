//
//  CCMatchViewController.m
//  NBA
//
//  Created by lanou3g on 16/7/6.
//  Copyright © 2016年 chao. All rights reserved.
//

#import "CCMatchViewController.h"
#import "MatchTableViewCell.h"
#import "MatchModel.h"
@interface CCMatchViewController ()<UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel *datetitle;
@property (weak, nonatomic) IBOutlet UITableView *rootTableView;
@property (weak, nonatomic) IBOutlet UITableView *leftTableView;
@property (weak, nonatomic) IBOutlet UITableView *rightTableView;
@property (weak, nonatomic) IBOutlet UIScrollView *rootScrollView;
@property (nonatomic,strong)NSMutableDictionary *dateDic;
@property (nonatomic,assign)NSInteger dateNum;
@end
static NSString * const MatchTableViewCellID = @"MatchTableViewCell";
@implementation CCMatchViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBar.barTintColor = [UIColor blueColor];
    self.dateNum = 0;
    [self setTableView];
    [self loadTableView];
}
- (void)setTableView{
    self.rootTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self refreshTableView];
    }];
    [self.rootTableView registerNib:[UINib nibWithNibName:@"MatchTableViewCell" bundle:nil] forCellReuseIdentifier:MatchTableViewCellID];
    [self.leftTableView registerNib:[UINib nibWithNibName:@"MatchTableViewCell" bundle:nil] forCellReuseIdentifier:MatchTableViewCellID];
    [self.rightTableView registerNib:[UINib nibWithNibName:@"MatchTableViewCell" bundle:nil] forCellReuseIdentifier:MatchTableViewCellID];
}
- (void)loadTableView{
    if (![self.dateDic objectForKey:[self dateTime]]){
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        NSString *url = [NSString stringWithFormat:@"http://sportsnba.qq.com/match/listByDate?appver=1.0.2&appvid=1.0.2&date=%@&deviceId=CA0D1337-38E7-441E-9611-26B9FAAA6272&from=app&guid=CA0D1337-38E7-441E-9611-26B9FAAA6272&height=667&network=WiFi&os=iphone&osvid=9.3.2&width=375",[self dateTime]];
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        [manager GET:url parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
    
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            if (responseObject != nil) {
                NSMutableArray *mArr = [NSMutableArray array];
                NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers | NSJSONReadingMutableLeaves error:nil];
                for (NSDictionary *mDic in dic[@"data"][@"matches"]) {
                    MatchModel *model = [MatchModel new];
                    [model setValuesForKeysWithDictionary:mDic[@"matchInfo"]];
                    [mArr addObject:model];
                }
                [self.dateDic setObject:mArr forKey:[self dateTime]];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                    [self reloadTableView];
                });
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSLog(@"%@",error);
        }];
    }else{
        [self reloadTableView];
    }
}
- (void)refreshTableView{
    NSString *url = [NSString stringWithFormat:@"http://sportsnba.qq.com/match/listByDate?appver=1.0.2&appvid=1.0.2&date=%@&deviceId=CA0D1337-38E7-441E-9611-26B9FAAA6272&from=app&guid=CA0D1337-38E7-441E-9611-26B9FAAA6272&height=667&network=WiFi&os=iphone&osvid=9.3.2&width=375",[self dateTime]];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager GET:url parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        NSLog(@"%@",downloadProgress);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (responseObject != nil) {
            NSMutableArray *modelArr = [NSMutableArray array];
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers | NSJSONReadingMutableLeaves error:nil];
            for (NSDictionary *mDic in dic[@"data"][@"matches"]) {
                MatchModel *model = [MatchModel new];
                [model setValuesForKeysWithDictionary:mDic[@"matchInfo"]];
                [modelArr addObject:model];
            }
            [self.dateDic setObject:modelArr forKey:[self dateTime]];
            [self.rootTableView reloadData];
            [self.rootTableView.mj_header endRefreshing];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
    }];
}
- (void)reloadTableView{
    [self.rootScrollView setContentOffset:(CGPointMake(CGRectGetWidth(self.rootScrollView.bounds), 0))];
    [self.rootTableView setContentOffset:(CGPointMake(0, 0)) animated:NO];
    [self.rootTableView reloadData];
    [self.leftTableView reloadData];
    [self.rightTableView reloadData];
    self.datetitle.text = [self datetitletext];
}
#pragma mark //////////////////////////delegate////////////////////////////
//tableView
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MatchTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MatchTableViewCellID];
    if ([self getModelArrayWithTableView:tableView]) {
        cell.model = [self getModelArrayWithTableView:tableView][indexPath.section];
    }
    return cell;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return [self getModelArrayWithTableView:tableView].count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section == [self getModelArrayWithTableView:tableView].count - 1) {
        return 15;
    }
    return 0.1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 15;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 200;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self getModelArrayWithTableView:tableView];
}
//scollView
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if ([scrollView isKindOfClass:[UITableView class]]) {
        return;
    }
    if (scrollView.contentOffset.x == 0) {
        self.dateNum --;
        [self loadTableView];
    }
    if (scrollView.contentOffset.x == self.view.width * 2) {
        self.dateNum ++;
        [self loadTableView];
    }
}
#pragma mark //////////////////////////懒加载////////////////////////////
-(NSMutableDictionary *)dateDic{
    if (!_dateDic) {
        _dateDic = [NSMutableDictionary dictionary];
    }
    return _dateDic;
}
#pragma mark //////////////////////////xib 方法////////////////////////////
- (IBAction)leftbtn:(id)sender {
    if (self.dateNum - 1 >= -10) {
        self.dateNum --;
        [self loadTableView];
    }
}
- (IBAction)rightbtn:(id)sender {
    if (self.dateNum + 1 <= 1) {
        self.dateNum ++;
        [self loadTableView];
    }
}
- (IBAction)calendar:(id)sender {
    //日历点击方法
}
- (NSString *)datetitletext{
    NSDate *date = [NSDate date];
    return [[self dateTime] isEqualToString: [DateTime dateTimeWithDate:date]] ? @"今日" : [DateTime weekTimeWithDate:[NSDate dateWithTimeIntervalSinceNow:24*60*60*(self.dateNum)]];
}
#pragma mark //////////////////////////date方法////////////////////////////
- (NSString *)dateTime{
    return [self dateTimeWithNum:self.dateNum];
}
- (NSString *)dateTimeWithNum:(NSInteger)dataNum{
    NSDate *date = [NSDate dateWithTimeIntervalSinceNow:24*60*60*(dataNum)];
    return [DateTime dateTimeWithDate:date];
}
#pragma mark //////////////////////////获取model数组////////////////////////////
- (NSMutableArray *)getModelArrayWithTableView:(UITableView *)tableView{
    NSInteger num = 0;
    if (tableView == self.rootTableView) {
        num = self.dateNum;
    }
    if (tableView == self.leftTableView) {
        num = self.dateNum-1;
    }
    if (tableView == self.rightTableView) {
        num = self.dateNum+1;
    }
    return [self.dateDic objectForKey:[self dateTimeWithNum:num]] ? [self.dateDic objectForKey:[self dateTimeWithNum:num]] : nil;
}
@end
