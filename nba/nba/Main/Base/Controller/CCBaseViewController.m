//
//  CCBaseViewController.m
//  NBA
//
//  Created by lanou3g on 16/7/6.
//  Copyright © 2016年 chao. All rights reserved.
//

#import "CCBaseViewController.h"
#import "CCNewViewController.h"
#import "CCMatchViewController.h"
#import "CCMoreViewController.h"
#import "CCVideoViewController.h"
#import "CCBaseNaviViewController.h"
@interface CCBaseViewController ()

@end

@implementation CCBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UITabBarItem *item = [UITabBarItem appearance];
    NSDictionary *attrs = @{NSFontAttributeName:[UIFont systemFontOfSize:12],NSForegroundColorAttributeName:[UIColor lightGrayColor]};
    NSDictionary *selectAttrs = @{NSFontAttributeName:[UIFont systemFontOfSize:12],NSForegroundColorAttributeName:[UIColor whiteColor]};
    [item setTitleTextAttributes:attrs forState:(UIControlStateNormal)];
    [item setTitleTextAttributes:selectAttrs forState:(UIControlStateSelected)];
    [self addChildViewController:[[CCNewViewController alloc] init] title:@"最新" image:@"最新"];
    [self addChildViewController:[[CCMatchViewController alloc] init] title:@"比赛" image:@"发起比赛"];
    [self addChildViewController:[[CCVideoViewController alloc] init] title:@"视频" image:@"视频"];
    self.tabBar.translucent = NO;
    self.tabBar.backgroundColor = [UIColor whiteColor];
    self.tabBar.tintColor = [UIColor whiteColor];
    self.tabBar.barTintColor = [UIColor CCcolor];
    self.view.backgroundColor = [UIColor whiteColor];
}
- (void)addChildViewController:(UIViewController *)vc title:(NSString *)title image:(NSString *)image{
    CCBaseNaviViewController *nc = [[CCBaseNaviViewController alloc] initWithRootViewController:vc];
    nc.navigationBar.translucent = NO;
    vc.title = title;
    vc.tabBarItem.image = [UIImage imageNamed:image];
    [self addChildViewController:nc];
}

@end
