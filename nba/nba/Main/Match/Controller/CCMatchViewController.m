//
//  CCMatchViewController.m
//  NBA
//
//  Created by lanou3g on 16/7/6.
//  Copyright © 2016年 chao. All rights reserved.
//

#import "CCMatchViewController.h"
#import "MatchDetailViewController.h"
#import "MatchTableViewCell.h"
#import "MatchModel.h"
#import "CCCalendarViewController.h"
@interface CCMatchViewController ()<UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate,MatchTableViewCellDelegate>
@property (nonatomic,strong)NSString *dateStr;
@property (nonatomic,strong)NSArray *dateArr;    //时间栏所有标题
@property (weak, nonatomic) IBOutlet UILabel *datetitle;
@property (weak, nonatomic) IBOutlet UITableView *rootTableView;
@property (weak, nonatomic) IBOutlet UITableView *leftTableView;
@property (weak, nonatomic) IBOutlet UITableView *rightTableView;
@property (weak, nonatomic) IBOutlet UIScrollView *rootScrollView;
@property (nonatomic,strong)NSMutableDictionary *dateDic;
@property (nonatomic,assign)NSInteger dateNum;
@property (weak, nonatomic) IBOutlet UIButton *leftBtn;
@property (weak, nonatomic) IBOutlet UIButton *rightBtn;
@end
static NSString * const MatchTableViewCellID = @"MatchTableViewCell";
@implementation CCMatchViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self setTableView];
    [self requestWithDateStr:_dateStr];
}
- (void)setTableView{
    [self setTableView:self.rootTableView];
    [self setTableView:self.leftTableView];
    [self setTableView:self.rightTableView];
}
- (void)setTableView:(UITableView *)tableView{
    tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self refreshTableView:tableView];
    }];
    [tableView registerNib:[UINib nibWithNibName:@"MatchTableViewCell" bundle:nil] forCellReuseIdentifier:MatchTableViewCellID];
}
//请求所有时间栏标题
- (void)requestWithDateStr:(NSString *)dateStr{
    if (!dateStr) {
        dateStr = [DateTime dateTimeWithDate:[NSDate date]];
    }
    NSString *url = [NSString stringWithFormat:@"http://sportsnba.qq.com/match/calendarNavBar?needInfo=1&appver=1.1&appvid=1.1&date=%@&deviceId=CA0D1337-38E7-441E-9611-26B9FAAA6272&from=app&guid=CA0D1337-38E7-441E-9611-26B9FAAA6272&height=667&network=WiFi&os=iphone&osvid=9.3.2&width=375",dateStr];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager GET:url parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers | NSJSONReadingMutableLeaves error:nil];
        self.dateArr = dic[@"data"][@"list"];
        //确定self.dateNum的初始值
        [self setDateNum];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
    }];
}
- (void)setDateNum{
    self.dateNum = -1;
    //获取当前时间戳
    for (NSString *str in self.dateArr) {
        if ([str intValue] > [[DateTime timeStrWithDate:[NSDate date]] intValue]) {
            if ([self.dateArr indexOfObject:str] == 0) {
                self.dateNum = 0;
            }else{
                self.dateNum = [self.dateArr indexOfObject:str] - 1;
            }
            break;
        }
    }
    if (self.dateNum == -1) {
        self.dateNum = self.dateArr.count - 1;
    }
    [self loadTableView];
}
- (void)loadTableView{
     //根据时间戳确定置中哪个tableView
    if (self.dateNum == self.dateArr.count - 1) {
        [self.rootScrollView setContentOffset:(CGPointMake(CGRectGetWidth(self.rootScrollView.bounds)*2, 0))];
        [self loadTableView:self.rightTableView];
    }else if(self.dateNum == 0){
        [self loadTableView:self.leftTableView];
    }else{
        [self.rootScrollView setContentOffset:(CGPointMake(CGRectGetWidth(self.rootScrollView.bounds), 0))];
        [self loadTableView:self.rootTableView];
    }
}
- (void)loadTableView:(UITableView *)tableView{
    if (![self.dateDic objectForKey:[self.dateArr objectAtIndex:self.dateNum]]){
        [tableView.mj_header beginRefreshing];
    }else{
        [self reloadTableView];
    }
}
- (void)refreshTableView:(UITableView *)tableView{
    NSString *dateStr = [DateTime dateTimeWithDate:[DateTime dateWithTimeString:[self.dateArr objectAtIndex:self.dateNum]]];
    NSString *url = [NSString stringWithFormat:@"http://sportsnba.qq.com/match/listByDate?appver=1.0.2&appvid=1.0.2&date=%@&deviceId=CA0D1337-38E7-441E-9611-26B9FAAA6272&from=app&guid=CA0D1337-38E7-441E-9611-26B9FAAA6272&height=667&network=WiFi&os=iphone&osvid=9.3.2&width=375",dateStr];
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
            [self.dateDic setObject:mArr forKey:[self.dateArr objectAtIndex:self.dateNum]];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self reloadTableView];
                [tableView.mj_header endRefreshing];
            });
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
    }];
}
- (void)reloadTableView{
    if (self.dateNum != 0 && self.dateNum != self.dateArr.count - 1) {
        [self.rootScrollView setContentOffset:(CGPointMake(CGRectGetWidth(self.rootScrollView.bounds), 0))];
        [self.rootTableView setContentOffset:(CGPointMake(0, 0)) animated:NO];
    }
    self.datetitle.text = [self datetitletext];
    [self.rootTableView reloadData];
    [self.leftTableView reloadData];
    [self.rightTableView reloadData];
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
//    cell.delegate = self;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
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
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if ([scrollView isKindOfClass:[UITableView class]]) {
        return;
    }
    if (scrollView.contentOffset.x == 0) {
        if (self.dateNum > 0) {
            self.dateNum --;
            [self loadTableView];
        }
    }
    if (scrollView.contentOffset.x == self.view.width * 2) {
        if (self.dateNum < self.dateArr.count - 1) {
            self.dateNum ++;
            [self loadTableView];
        }
    }
    if (scrollView.contentOffset.x == self.view.width) {
        if (self.dateNum == 0) {
            self.dateNum ++;
        }
        if (self.dateNum == self.dateArr.count - 1) {
            self.dateNum --;
        }
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
- (IBAction)leftbtn:(UIButton *)sender {
    if (self.dateNum  != 0) {
        self.dateNum --;
        [self loadTableView];
    }
}
- (IBAction)rightbtn:(UIButton *)sender {
    if (self.dateNum != self.dateArr.count - 1) {
        self.dateNum ++;
        [self loadTableView];
    }
}
- (IBAction)calendar:(id)sender {
//    //日历点击方法
//    CCCalendarViewController *vc = [[CCCalendarViewController alloc] init];
//    vc.date = [NSDate dateWithTimeIntervalSinceNow:24*60*60*(self.dateNum)];
//    [self.navigationController pushViewController:vc animated:YES];
}
- (NSString *)datetitletext{
    NSDate *date = [NSDate date];
    NSString *dateStr = [DateTime dateTimeWithDate:[DateTime dateWithTimeString:[self.dateArr objectAtIndex:self.dateNum]]];
    return [dateStr isEqualToString: [DateTime dateTimeWithDate:date]] ? @"今日" : [DateTime weekTimeWithDate:[DateTime dateWithTimeString:[self.dateArr objectAtIndex:self.dateNum]]];
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
    NSInteger dateNum = 0;
    if (self.dateNum == 0) {
        dateNum = 1;
    }else if (self.dateNum == self.dateArr.count - 1) {
        dateNum = self.dateNum - 1;
    }else{
        dateNum = self.dateNum;
    }
    if (tableView == self.rootTableView) {
        num = dateNum;
    }
    if (tableView == self.leftTableView) {
        num = dateNum-1;
    }
    if (tableView == self.rightTableView) {
        num = dateNum+1;
    }
    return [self.dateDic objectForKey:[self.dateArr objectAtIndex:num]] ? [self.dateDic objectForKey:[self.dateArr objectAtIndex:num]] : nil;
}
#pragma mark //////////////////////////cell代理////////////////////////////
- (void)tapTableViewCell:(MatchTableViewCell *)tableViewCell withType:(NSString *)type mid:(NSString *)mid{
    MatchDetailViewController *vc = [[MatchDetailViewController alloc] init];
    vc.type = type;
    vc.mid = mid;
    [self.navigationController pushViewController:vc animated:YES];
}
@end
