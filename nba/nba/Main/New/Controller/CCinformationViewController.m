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
@interface CCinformationViewController ()<UITableViewDelegate,UITableViewDataSource>

/**   */
@property (nonatomic,strong) UITableView *informationTableView;
/**   */
@property (nonatomic,strong) NSMutableArray *arr;

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
    self.informationTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 70) style:(UITableViewStyleGrouped)];
    self.informationTableView.delegate = self;
    self.informationTableView.dataSource = self;
    self.informationTableView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:self.informationTableView];
    
    // 注册cell
    UINib *nib = [UINib nibWithNibName:@"CCInformationTableViewCell" bundle:[NSBundle mainBundle]];
    [self.informationTableView registerNib:nib forCellReuseIdentifier:@"CCInformationTableViewCell"];
    
}


#pragma mark 请求数据
- (void)getRequest {
    NSString *url = @"http://sportsnba.qq.com/news/item?appver=1.0.2&appvid=1.0.2&articleIds=20160706046456%2C20160706031972%2C20160706028791%2C20160706011416%2C20160706019527%2C20160705058715%2C20160706000384%2C20160706004391%2C20160706003312%2C20160706002542%2C20160706000802%2C20160705016245%2C20160705012405%2C20160705006601%2C20160705001893%2C20160705001745%2C20160705001305%2C20160705000805%2C20160704043726%2C20160704039877&column=news&deviceId=CA0D1337-38E7-441E-9611-26B9FAAA6272&from=app&guid=CA0D1337-38E7-441E-9611-26B9FAAA6272&height=667&network=WiFi&os=iphone&osvid=9.3.2&width=375";
    [CCNewRequest getDataWithUrl:url par:nil successBlock:^(id data) {
        for (NSDictionary *dic  in [data[@"data"]allValues]) {
            CCInformationModel *model = [[CCInformationModel alloc] init];
//            NSLog(@"%@", dic);
            [model setValuesForKeysWithDictionary:dic];
            [self.arr addObject:model];
        }
        [self.informationTableView reloadData];
    } failBlock:^(NSError *err) {
        NSLog(@"line = %d,err = %@",__LINE__,err);
    }];
}




#pragma mark tableView代理方法
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 20;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CCInformationTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CCInformationTableViewCell" forIndexPath:indexPath];
    cell.model = _arr[indexPath.row];
    
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
//    self.inHeadTableView = tableView;
//    
//    if (section == 0) {
//        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 150)];
//        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(imageView.frame)-30, self.view.frame.size.width, 30)];
//        [imageView addSubview:label];
//        [self.inHeadTableView addSubview:imageView];
//        
//    }
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"1"]];
    imageView.frame = tableView.tableHeaderView.frame;
    return imageView;
}



@end
