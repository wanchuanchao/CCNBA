//
//  CCMatchViewController.m
//  NBA
//
//  Created by lanou3g on 16/7/6.
//  Copyright © 2016年 chao. All rights reserved.
//

#import "CCMatchViewController.h"
#import "MatchTableViewCell.h"
@interface CCMatchViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,strong)UITableView *rootTableView;
@property (nonatomic,strong)UICollectionView *rootCollectionView;
@property (nonatomic,strong)UISegmentedControl *rootSeg;
@end
static NSString * const MatchTableViewCellID = @"MatchTableViewCell";
@implementation CCMatchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTableView];
}
- (void)setTableView{
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBar.barTintColor = [UIColor blueColor];
    self.rootTableView = [[UITableView alloc] initWithFrame:CGRectMake(0,40, self.view.width, self.view.height+10) style:(UITableViewStyleGrouped)];
    NSLog(@"%f",self.view.width);
    self.rootTableView.delegate = self;
    self.rootTableView.dataSource = self;

    [self.view addSubview:self.rootTableView];
    [self.rootTableView registerNib:[UINib nibWithNibName:@"MatchTableViewCell" bundle:nil] forCellReuseIdentifier:MatchTableViewCellID];
}

#pragma mark //////////////////////////tableview.delegate////////////////////////////
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MatchTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MatchTableViewCellID];
    return cell;                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 10;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 15;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 250;
}
@end
