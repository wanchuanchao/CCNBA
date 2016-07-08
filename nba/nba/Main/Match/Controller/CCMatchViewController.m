//
//  CCMatchViewController.m
//  NBA
//
//  Created by lanou3g on 16/7/6.
//  Copyright © 2016年 chao. All rights reserved.
//

#import "CCMatchViewController.h"

@interface CCMatchViewController ()

@end

@implementation CCMatchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"string";
    self.view.backgroundColor = [UIColor whiteColor];
    UISegmentedControl *seg = [[UISegmentedControl alloc] initWithItems:@[@"简书",@"知乎"]];
    seg.backgroundColor = [UIColor whiteColor];
    seg.frame = CGRectMake(0, 0,100, 30);
    self.navigationItem.titleView = seg;
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
