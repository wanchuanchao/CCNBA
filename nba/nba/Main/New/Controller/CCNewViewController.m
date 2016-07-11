//
//  CCNewViewController.m
//  NBA
//
//  Created by lanou3g on 16/7/6.
//  Copyright © 2016年 chao. All rights reserved.
//

#import "CCNewViewController.h"
#import "CCHeadLineViewController.h"
#import "CCinformationViewController.h"
@interface CCNewViewController ()

@end

@implementation CCNewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    UISegmentedControl *segment = [[UISegmentedControl alloc] initWithItems:@[@"头条",@"资讯"]];
    segment.frame = CGRectMake(150, 30,50, 30);
    
    segment.backgroundColor = [UIColor whiteColor];
    [segment addTarget:self action:@selector(selectedSegmentIndexAction:) forControlEvents:(UIControlEventValueChanged)];
    self.navigationItem.titleView = segment;
}


// 设置子控制器
- (void)setChildViewController {
    CCHeadLineViewController *headLineVC = [[CCHeadLineViewController alloc] init];
    [self addChildViewController:headLineVC];
    
    CCinformationViewController *informationVC = [[CCinformationViewController alloc] init];
    [self addChildViewController:informationVC];
    
}

- (void)selectedSegmentIndexAction:(UISegmentedControl *)tag {
    NSInteger index = tag.selectedSegmentIndex;
}

@end
