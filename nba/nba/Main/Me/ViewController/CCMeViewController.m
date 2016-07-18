//
//  CCMeViewController.m
//  nba
//
//  Created by lanou3g on 16/7/14.
//  Copyright © 2016年 wanccao. All rights reserved.
//

#import "CCMeViewController.h"
#import "WCCDrawerViewController.h"
#import "CCLoginViewController.h"
@interface CCMeViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *rootTableView;

@end

@implementation CCMeViewController
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.rootTableView reloadData];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addObserver:self forKeyPath:@"frame" options:(NSKeyValueObservingOptionNew) context:NULL];
}
#pragma mark //////////////////////////代理////////////////////////////
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 2;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:(UITableViewCellStyleValue1) reuseIdentifier:@"cell"];
    NSString *titleStr = @"";
    if (indexPath.section == 0 && indexPath.row == 0) {
        titleStr = @"我的主队";
        cell.imageView.image = [UIImage imageNamed:@"主场"];
    }
    if (indexPath.section == 0 && indexPath.row == 1) {
        titleStr = @"推送消息";
        cell.imageView.image = [UIImage imageNamed:@"信封"];
    }
    if (indexPath.section == 1 && indexPath.row == 0) {
        titleStr = @"设置";
        cell.imageView.image = [UIImage imageNamed:@"设置"];
    }
    if (indexPath.section == 1 && indexPath.row == 1) {
        titleStr = @"清理缓存";
        cell.imageView.image = [UIImage imageNamed:@"清除缓存"];
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%.1fMB",[self getTmpSize]];
    }
    cell.textLabel.text = titleStr;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 20;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0 && indexPath.row == 0) {
        [self login];
    }
    if (indexPath.section == 0 && indexPath.row == 1) {
        
    }
    if (indexPath.section == 1 && indexPath.row == 0) {
        
    }
    if (indexPath.section == 1 && indexPath.row == 1) {
        [self clearTmp];
    }
}
- (float)getTmpSize{
    return (float)[[SDImageCache sharedImageCache] getSize]/1024/1024;
}
- (void)clearTmp{
    UILabel *alert = [[UILabel alloc] initWithFrame:(CGRectMake(0, 0, 50, 50))];
    if ([self getTmpSize]) {
        alert.text = [NSString stringWithFormat:@"已清理%.1fMB",[self getTmpSize]];
    }else{
        alert.text = @"暂无缓存";
    }
    alert.backgroundColor = [UIColor blackColor];
    alert.textColor = [UIColor whiteColor];
    [alert sizeToFit];
    alert.width +=50;
    alert.height += 20;
    alert.layer.cornerRadius = 5;
    alert.textAlignment = NSTextAlignmentCenter;
    alert.alpha = 0.7;
    alert.layer.masksToBounds= YES;
    alert.center = self.view.center;
    [self.view addSubview:alert];
    self.view.userInteractionEnabled = NO;
    //清理缓存
    [[SDImageCache sharedImageCache] clearDisk];
    [[SDImageCache sharedImageCache] clearMemory];
    [self.rootTableView reloadData];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [alert removeFromSuperview];
        self.view.userInteractionEnabled = YES;
    });
    NSLog(@"%@",self.view);
}
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context{
    if ([keyPath isEqualToString:@"frame"]) {
        if (self.view.x == 0) {
            [self.rootTableView reloadData];
        }
    }
}
- (WCCDrawerViewController *)getWCCDrawerVC{
    return (WCCDrawerViewController *)[[UIApplication sharedApplication].windows[0] rootViewController];
}
- (void)login{
    CCLoginViewController *vc = [[CCLoginViewController alloc] init];
    [[self getWCCDrawerVC] showViewController:vc animated:YES];
}

- (IBAction)login:(id)sender {
    [self login];
}
@end
