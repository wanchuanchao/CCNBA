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
@property (nonatomic,strong) NSMutableDictionary *dic;
@end

@implementation CCTeamViewController

// 懒加载
-(NSMutableDictionary *)dic{
    if (!_dic) {
        _dic = [NSMutableDictionary dictionary];
    }
    return _dic;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.teamTableView = [[UITableView alloc] initWithFrame:self.view.frame style:(UITableViewStyleGrouped)];
    self.teamTableView.delegate = self;
    self.teamTableView.dataSource = self;
    [self.view addSubview:self.teamTableView];
    [self getRequest];
}


- (void)getRequest {
    NSString *url = @"http://sportsnba.qq.com/team/list?appver=1.0.2&appvid=1.0.2&deviceId=C65DEA60-C052-4DAF-A742-C447246489F8&from=app&guid=C65DEA60-C052-4DAF-A742-C447246489F8&height=667&network=WiFi&os=iphone&osvid=9.3.2&width=375";
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager GET:url parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:(NSJSONReadingAllowFragments) error:nil];
        NSMutableArray *westArr = [NSMutableArray array];
        for (NSDictionary *mdic in dic[@"data"][@"west"]) {
            CCWestModel *westModel = [[CCWestModel alloc] init];
            [westModel setValuesForKeysWithDictionary:mdic];
            [westArr addObject:westModel];
        }
        NSMutableArray *eastArr = [NSMutableArray array];
        for (NSDictionary *mdic in dic[@"data"][@"east"]) {
            CCWestModel *eastModel = [[CCWestModel alloc] init];
            [eastModel setValuesForKeysWithDictionary:mdic];
            [eastArr addObject:eastModel];
        }
        [self.dic setObject:westArr forKey:@"west"];
        [self.dic setObject:eastArr forKey:@"east"];
        NSLog(@"%@",self.dic);
        [self.teamTableView reloadData];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if ([self.dic objectForKey:@"east"]) {
        if (section == 0) {
            return [self.dic[@"east"] count];
        }
        if (section == 1) {
            return [self.dic[@"west"] count];
        }
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (indexPath.section == 0) {
        cell.textLabel.text = self.dic[@"east"][indexPath.row][@"fullCnName"];
        cell.detailTextLabel.text = self.dic[@"east"][indexPath.row][@"city"];
        [cell.imageView sd_setImageWithURL:[NSURL URLWithString:self.dic[@"east"][indexPath.row][@"logo"]] placeholderImage:[UIImage imageNamed:@"1"]];
    }
    if (indexPath.section == 1) {
        cell.textLabel.text = self.dic[@"west"][indexPath.row][@"fullCnName"];
        cell.detailTextLabel.text = self.dic[@"west"][indexPath.row][@"city"];
        [cell.imageView sd_setImageWithURL:[NSURL URLWithString:self.dic[@"west"][indexPath.row][@"logo"]] placeholderImage:[UIImage imageNamed:@"1"]];
    }
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
