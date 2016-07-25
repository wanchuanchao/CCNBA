//
//  MatchDetailViewController.m
//  nba
//
//  Created by lanou3g on 16/7/13.
//  Copyright © 2016年 wanccao. All rights reserved.
//

#import "MatchDetailViewController.h"
#import "CCMatchDetailModel.h"
#import "CCBaseNaviViewController.h"
@interface MatchDetailViewController ()<UITableViewDataSource,UITableViewDelegate,UINavigationControllerDelegate>
@property (weak, nonatomic) IBOutlet UIView *teamsView;
@property (nonatomic,strong)UIView *statusBar;
@property (weak, nonatomic) IBOutlet UIView *showView;
@property (weak, nonatomic) IBOutlet UIStackView *headTabBarView;
@property (weak, nonatomic) IBOutlet UILabel *desc;
@property (weak, nonatomic) IBOutlet UILabel *leftScore;
@property (weak, nonatomic) IBOutlet UILabel *rightScore;
@property (weak, nonatomic) IBOutlet UILabel *teams;
@property (weak, nonatomic) IBOutlet UILabel *leftWinLosses;
@property (weak, nonatomic) IBOutlet UILabel *rightWinLosses;
@property (weak, nonatomic) IBOutlet UILabel *quarterDesc;
@property (weak, nonatomic) IBOutlet UIButton *letfBTN;
@property (weak, nonatomic) IBOutlet UIButton *rightBTN;
@property (weak, nonatomic) IBOutlet UILabel *startDate;
@property (weak, nonatomic) IBOutlet UIView *sliderView;
@property (weak, nonatomic) IBOutlet UIImageView *leftBadge;
@property (weak, nonatomic) IBOutlet UIImageView *rightBadge;
@property (nonatomic,strong)CCMatchDetailModel *model;
@property (weak, nonatomic) IBOutlet UIImageView *headBackImage;
@property (nonatomic,strong)UIImageView *navigationImageView;
@end

@implementation MatchDetailViewController
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.translucent = YES;
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"1111"] forBarMetrics:(UIBarMetricsCompact)];
    [self.navigationController.navigationBar setBackgroundColor:[UIColor CCcolorWithAlpha:0]];
    self.navigationImageView.hidden = YES;
    [self.navigationController.navigationBar addSubview:self.statusBar];
}
-(void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    self.statusBar.backgroundColor = [UIColor CCcolorWithAlpha:0];
    self.navigationImageView.hidden = NO;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadRequestHeadView];
    self.statusBar = [[UIView alloc] initWithFrame:(CGRectMake(0, -20, WIDTH, 20))];
    UIImageView *navigationImageView = [self findHairlineImageViewUnder:self.navigationController.navigationBar];
    self.navigationImageView = navigationImageView;
}
- (void)loadRequestHeadView{
    NSString *url = [NSString stringWithFormat:@"http://sportsnba.qq.com/match/baseInfo?appver=1.1&appvid=1.1&deviceId=CA0D1337-38E7-441E-9611-26B9FAAA6272&from=app&guid=CA0D1337-38E7-441E-9611-26B9FAAA6272&height=667&mid=%@&network=WiFi&os=iphone&osvid=9.3.2&width=375",self.mid];
    self.model = [[CCMatchDetailModel alloc] init];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager GET:url parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:(NSJSONReadingAllowFragments) error:nil];
        [self.model setValuesForKeysWithDictionary:dic[@"data"]];
        [self setHeadTabBarView];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}
- (void)setHeadTabBarView{
    self.navigationItem.title = [NSString stringWithFormat:@"%@@%@",self.model.leftName,self.model.rightName];
    if ([_model.quarterDesc isEqualToString:@""]) {
        //比赛没开始
        self.quarterDesc.text = _model.startHour;
        self.leftScore.text = @"-";
        self.rightScore.text = @"-";
    }else{
        NSArray *strArr = [_model.quarterDesc componentsSeparatedByString:@" "];
        if (![strArr.firstObject isEqualToString:@"第一节"] &&![strArr.firstObject isEqualToString:@"第二节"] &&![strArr.firstObject isEqualToString:@"第三节"] && [strArr.lastObject isEqualToString:@"00:00"] && _model.rightGoal != _model.leftGoal) {
            //比赛结束
            self.quarterDesc.text = @"已结束";
        }else{
            //比赛进行中
            self.quarterDesc.text = [NSString stringWithFormat:@"直播 %@",_model.quarterDesc];
            self.quarterDesc.textColor = [UIColor redColor];
        }
        self.leftScore.text = _model.leftGoal;
        self.rightScore.text = _model.rightGoal;
    }
    SDWebImageManager *manager = [SDWebImageManager sharedManager];
    [self.leftBadge sd_setImageWithURL:[NSURL URLWithString:_model.leftBadge] placeholderImage:[UIImage imageNamed:@"1"]];
    [manager downloadImageWithURL:[NSURL URLWithString:_model.leftBadge] options:SDWebImageRetryFailed progress:^(NSInteger receivedSize, NSInteger expectedSize) {
        
    } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
        
    }];
    [self.rightBadge sd_setImageWithURL:[NSURL URLWithString:_model.rightBadge]];
    [manager downloadImageWithURL:[NSURL URLWithString:_model.rightBadge] options:SDWebImageRetryFailed progress:^(NSInteger receivedSize, NSInteger expectedSize) {
        
    } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
        
    }];
    self.desc.text = _model.desc;

}
#pragma mark //////////////////////////delegate////////////////////////////
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 100;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:@"cell"];
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat offsetY = scrollView.contentOffset.y;
    NSLog(@"%f",offsetY);
    if (- 64 - offsetY >= -140 && - 64 - offsetY <= 0) {
        [self.navigationController.navigationBar setBackgroundColor:[UIColor CCcolorWithAlpha:(64 + offsetY)/140.0]];
        self.statusBar.backgroundColor = [UIColor CCcolorWithAlpha:(64 + offsetY)/140.0];
        CGRect frame = self.view.frame;
        frame.origin.y = - 64 - offsetY;
        self.view.frame = frame;
        [self.view layoutSubviews];
    }
}
#pragma mark //////////////////////////pan手势////////////////////////////
- (IBAction)pan:(UIPanGestureRecognizer *)sender {
    
}
-(UIImageView *)findHairlineImageViewUnder:(UIView *)view {
    
    if ([view isKindOfClass:UIImageView.class] && view.bounds.size.height <= 1.0) {
        return (UIImageView *)view;
    }
    for (UIView *subview in view.subviews) {
        UIImageView *imageView = [self findHairlineImageViewUnder:subview];
        if (imageView) {
            return imageView;
        }
    }
    return nil;
}
@end
