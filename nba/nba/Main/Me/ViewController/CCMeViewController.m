//
//  CCMeViewController.m
//  nba
//
//  Created by lanou3g on 16/7/14.
//  Copyright © 2016年 wanccao. All rights reserved.
//

#import "CCMeViewController.h"

@interface CCMeViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *rootTableViw;

@end

@implementation CCMeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 2;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:@"cell"];
    NSString *titleStr = @"";
    if (indexPath.section == 0 && indexPath.row == 0) {
        titleStr = @"我的主队";
    }
    if (indexPath.section == 0 && indexPath.row == 1) {
        titleStr = @"推送消息";
    }
    if (indexPath.section == 1 && indexPath.row == 0) {
        titleStr = @"设置";
    }
    if (indexPath.section == 1 && indexPath.row == 1) {
        titleStr = @"清理缓存";
    }
    cell.textLabel.text = titleStr;
    return cell;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 20;
}
@end
