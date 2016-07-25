//
//  CCTeamViewController.m
//  nba
//
//  Created by lanou3g on 16/7/23.
//  Copyright © 2016年 wanccao. All rights reserved.
//

#import "CCTeamViewController.h"
#import "CCAllTableViewCell.h"
#import "CCNewRequest.h"
#import "CCEastModel.h"
#import "CCWestModel.h"
@interface CCTeamViewController ()<UITableViewDelegate,UITableViewDataSource>
/**   */
@property (nonatomic,strong) UITableView *teamTableView;
/**   */
@property (nonatomic,strong) NSMutableArray *arr;
@end

@implementation CCTeamViewController

// 懒加载
- (NSMutableArray *)arr{
    if (!_arr) {
        _arr = [NSMutableArray array];
    }
    return _arr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.teamTableView = [[UITableView alloc] initWithFrame:self.view.frame style:(UITableViewStylePlain)];
    self.teamTableView.delegate = self;
    self.teamTableView.dataSource = self;
    [self.view addSubview:self.teamTableView];
    
    [self.teamTableView registerNib:[UINib nibWithNibName:@"cell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"cell"];
}


- (void)getRequest {
    NSString *url = @"http://sportsnba.qq.com/team/list?appver=1.0.2&appvid=1.0.2&deviceId=C65DEA60-C052-4DAF-A742-C447246489F8&from=app&guid=C65DEA60-C052-4DAF-A742-C447246489F8&height=667&network=WiFi&os=iphone&osvid=9.3.2&width=375";
    
    [CCNewRequest getDataWithUrl:url par:nil successBlock:^(id data) {
        for (NSDictionary *dic in data[@"data"][@"west"]) {
            CCWestModel *westModel = [[CCWestModel alloc] init];
            [westModel setValuesForKeysWithDictionary:dic];
            [self.arr addObject:westModel];
        }
        for (NSDictionary *dic in data[@"data"][@"west"]) {
            CCEastModel *eastModel = [[CCEastModel alloc] init];
            [eastModel setValuesForKeysWithDictionary:dic];
            [self.arr addObject:eastModel];
        }
    } failBlock:^(NSError *err) {
        NSLog(@"line = %d,err = %@",__LINE__,err);
    }];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.arr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CCAllTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    return cell;
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 80;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 40;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return @"东部";
    }
    return @"西部";
}
@end
