//
//  CCinformationViewController.m
//  NBA
//
//  Created by lanou3g on 16/7/8.
//  Copyright © 2016年 chao. All rights reserved.
//

#import "CCinformationViewController.h"
#import "CCInformationTableViewCell.h"
#import "CCNewRequest.h"
#import "CCInformationModel.h"
#import <UIImageView+WebCache.h>
#import "CCinformationTwoViewController.h"
#import <MJRefresh.h>
@interface CCinformationViewController ()<UITableViewDelegate,UITableViewDataSource>

/**   */
@property (nonatomic,strong) UITableView *informationTableView;
/**   */
@property (nonatomic,strong) NSMutableArray *arr;

@property (nonatomic,strong) UIButton *headBtn;

@end

@implementation CCinformationViewController

// 懒加载
- (NSMutableArray *)arr{
    if (!_arr) {
        _arr = [NSMutableArray array];
    }
    return _arr;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self setTableView];
    [self getRequest];
}

- (void)setTableView {
    self.informationTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 35, self.view.frame.size.width, self.view.frame.size.height - 70) style:(UITableViewStyleGrouped)];
    self.informationTableView.delegate = self;
    self.informationTableView.dataSource = self;
    self.informationTableView.showsVerticalScrollIndicator = NO;
    self.informationTableView .separatorStyle = NO;
    [self.view addSubview:self.informationTableView];
    
    // 注册cell
    UINib *nib = [UINib nibWithNibName:@"CCInformationTableViewCell" bundle:[NSBundle mainBundle]];
    [self.informationTableView registerNib:nib forCellReuseIdentifier:@"CCInformationTableViewCell"];
    
    
    MJRefreshNormalHeader* header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self performSelector:@selector(headRefresh)withObject:nil afterDelay:2.0f];
    }];
    //设置自定义文字，因为默认是英文的
    [header setTitle:@"下拉刷新"forState:MJRefreshStateIdle];
    [header setTitle:@"松开加载更多"forState:MJRefreshStatePulling];
    [header setTitle:@"正在刷新中"forState:MJRefreshStateRefreshing];
    
    self.informationTableView.mj_header= header;
    [self.informationTableView.mj_header beginRefreshing];
    [self getRequest];
    //创建上拉刷新
    MJRefreshBackNormalFooter * foot =[MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        
        [self performSelector:@selector(footRefresh)withObject:nil afterDelay:2.0f];
        
    }];
    self.informationTableView.mj_footer= foot;
    
    [foot setTitle:@"上拉刷新"forState:MJRefreshStateIdle];
    [foot setTitle:@"松开加载更多"forState:MJRefreshStatePulling];
    [foot setTitle:@"正在刷新中"forState:MJRefreshStateRefreshing];
    
}



// 上拉刷新下拉加载
- (void)headRefresh {
    NSLog(@"下拉,加载数据");
    [self.informationTableView reloadData];
    [self getRequest];
}
- (void)footRefresh {
    NSLog(@"上拉，加载数据");
    [self.informationTableView.mj_footer endRefreshing];
}



#pragma mark 请求数据
- (void)getRequest {
    NSMutableString *urlStr = [NSMutableString string];
    NSString *url = @"http://url.cn/2KZ1Rh2";
    [CCNewRequest getDataWithUrl:url par:nil successBlock:^(id data) {
        for (NSDictionary *dic in data[@"data"]) {
            NSString *string = dic[@"id"];
            [urlStr appendFormat:@"%%2c%@",string];
        }
        NSString *string = [urlStr substringFromIndex:3];
        [CCNewRequest getDataWithUrl:[NSString stringWithFormat:@"http://sportsnba.qq.com/news/item?appver=1.1&appvid=1.1&articleIds=%@&column=news&deviceId=CA0D1337-38E7-441E-9611-26B9FAAA6272&from=app&guid=CA0D1337-38E7-441E-9611-26B9FAAA6272&height=667&network=WiFi&os=iphone&osvid=9.3.2&width=375",string] par:nil successBlock:^(id data) {
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
                CCInformationModel *model = [[CCInformationModel alloc] init];
                [model setValuesForKeysWithDictionary:[data[@"data"] valueForKey:string1]];
                [self.arr addObject:model];
            }
            
            if ([self.informationTableView.mj_header isRefreshing]) {
                [self.informationTableView.mj_header endRefreshing];
            }
        } failBlock:^(NSError *err) {
            NSLog(@"line = %d,err = %@",__LINE__,err);
        }];
    } failBlock:^(NSError *err) {
        NSLog(@"line = %d,err = %@",__LINE__,err);
    }];
    
}




#pragma mark tableView代理方法
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.arr.count - 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CCInformationTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CCInformationTableViewCell" forIndexPath:indexPath];
    cell.model = _arr[indexPath.row+1];
    return cell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 80;
}

#pragma mark 头视图的代理方法
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 200;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    
    
    // 取出数组里的第一段数据,加在头视图上
    CCInformationModel *model = (CCInformationModel *)self.arr.firstObject;
    // 加载头视图图片
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.frame = CGRectMake(0, 0, self.view.frame.size.width, 200);
    [imageView sd_setImageWithURL:[NSURL URLWithString:model.imgurl] placeholderImage:[UIImage imageNamed:@"jordon"]];
    // 加载头视图标题
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 180, self.view.frame.size.width , 20)];
    label.text = [NSString stringWithFormat:@"  %@",model.title];
    label.textColor = [UIColor whiteColor];
    label.backgroundColor = [UIColor blackColor];
    label.alpha = 0.7f;
    [imageView addSubview:label];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(btnAction)];
    [imageView addGestureRecognizer:tap];
    imageView.userInteractionEnabled = YES;
    
    return imageView;
}

// btn的点击事件
- (void)btnAction{
    CCinformationTwoViewController *ccVC = [CCinformationTwoViewController new];
    ccVC.url =((CCInformationModel *)self.arr[0]).url;
    [self.navigationController pushViewController:ccVC animated:YES];
    NSLog(@"跳转");
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    CCinformationTwoViewController *ccVC = [CCinformationTwoViewController new];
    ccVC.url = ((CCInformationModel *)self.arr[indexPath.row +1]).url;
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:ccVC animated:YES];
    self.hidesBottomBarWhenPushed = NO;
}













@end
