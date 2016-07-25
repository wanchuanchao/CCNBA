//
//  CCBaseNaviViewController.m
//  nba
//
//  Created by lanou3g on 16/7/23.
//  Copyright © 2016年 wanccao. All rights reserved.
//

#import "CCBaseNaviViewController.h"

@interface CCBaseNaviViewController ()

@end

@implementation CCBaseNaviViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    self.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationBar.barTintColor = [UIColor CCcolor];
    NSDictionary * dict = [NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName,[UIFont systemFontOfSize:20],NSFontAttributeName,nil];
    self.navigationBar.titleTextAttributes = dict;
    [[UIBarButtonItem appearance] setTitleTextAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:15]} forState:(UIControlStateNormal)];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
