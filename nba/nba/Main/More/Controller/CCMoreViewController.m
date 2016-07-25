//
//  CCMoreViewController.m
//  NBA
//
//  Created by lanou3g on 16/7/6.
//  Copyright © 2016年 chao. All rights reserved.
//

#import "CCMoreViewController.h"
#import "CCMoreTableViewCell.h"
@interface CCMoreViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,strong) UITableView *rootTableView;
/**  数组 */
@property (nonatomic,strong) NSMutableArray *arr;
@end

@implementation CCMoreViewController

// 懒加载
//- (NSMutableArray *)arr{
//    if (!_arr) {
//        _arr = [NSMutableArray array];
//    }
//    return _arr;
//}

- (void)viewDidLoad {
//    [super viewDidLoad];
//    self.rootTableView = [[UITableView alloc] initWithFrame:self.view.frame style:(UITableViewStyleGrouped)];
//    self.rootTableView.delegate = self;
//    self.rootTableView.dataSource = self;
//    [self.view addSubview:self.rootTableView];
//    
//    UINib *nib = [UINib nibWithNibName:@"cell" bundle:[NSBundle mainBundle]];
//    [self.rootTableView registerNib:nib forCellReuseIdentifier:@"cell"];
    
}
//#pragma mark //////////////////////////代理////////////////////////////
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
//    return 6;
//}
//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
//    CCMoreTableViewCell *cell = [[CCMoreTableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:@"cell"];
//    switch (indexPath.row) {
//        case 0:
//            
//            break;
//        case 1:
//            
//            break;
//        case 2:
//            
//            break;
//    }
//    return cell;
//}
//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
//    return 1;
//}
//
//
//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
//    
//    return 50;
//}
//
//- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
//    return @"内容";
//}
//
//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
//    return 30;
//}

@end
