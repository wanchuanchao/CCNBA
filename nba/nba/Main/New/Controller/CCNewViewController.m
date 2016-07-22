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
@interface CCNewViewController ()<UIScrollViewDelegate>

/**  导航栏图标 */
@property (nonatomic,strong) UIButton *navBtn;
/**  头条控制器 */
@property (nonatomic,strong) CCHeadLineViewController *headLineVC;
/**  资讯控制器 */
@property (nonatomic,strong) CCinformationViewController *informationVC;
/**  标签栏底部红色的指示器  */
@property (nonatomic,strong)UIView * indicatorView;
/**  当前选中的按钮  */
@property (nonatomic,strong)UIButton * selectButton;
/**  顶部的所有标签  */
@property (nonatomic,strong)UIView * titleView;
/**  底部的ScrollView  */
@property (nonatomic,strong)UIScrollView * scrollView;


@end

@implementation CCNewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUpChildViewController];
    [self setUpScrollView];
    [self setUpTitlesView];
    [self addChildVcView];

}

//设置顶部标签栏
-(void)setUpTitlesView{
    UIView *titlesView = [[UIView alloc]init];
    titlesView.backgroundColor = [[UIColor whiteColor]colorWithAlphaComponent:1];
    titlesView.width = self.view.width;
    titlesView.height = 35;
    titlesView.y = 0;
    [self.view addSubview:titlesView];
    
    // 底部红色横线
    self.indicatorView = [[UIView alloc]init];
    self.indicatorView.backgroundColor = [UIColor blueColor];
    self.indicatorView.height = 2;
    self.indicatorView.y = titlesView.height - self.indicatorView.height;
    
    // 内部的子标签
    NSArray * titles = @[@"头条",@"资讯"];
    CGFloat width = titlesView.width/ titles.count;
    CGFloat height = titlesView.height;
    for (NSInteger i = 0 ; i<titles.count; i++) {
        UIButton * button = [[UIButton alloc]init];
        button.tag = i;
        button.height = height;
        button.width = width;
        button.x = i * width;
        [button setTitle:titles[i] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor blueColor] forState:UIControlStateDisabled];
        button.titleLabel.font = [UIFont fontWithName:@"Arial-BoldMT" size:15.0f];
        [button addTarget:self action:@selector(tilteClick:) forControlEvents:UIControlEventTouchUpInside];
        [titlesView addSubview:button];
        
        //默认点击了一个按钮
        if (i == 0) {
            button.enabled = NO;
            self.selectButton = button;
            //让按钮内部的label根据文字内容来计算尺寸
            [button.titleLabel sizeToFit];
            self.indicatorView.width = button.width;
            
            self.indicatorView.y = button.maxY - 2;
        }
    }
    self.titleView = titlesView;
    [titlesView addSubview:self.indicatorView];
}
// 点击标签导航栏事件
- (void)tilteClick:(UIButton *)sender{
    // 修改按钮状态
    self.selectButton.enabled = YES;
    sender.enabled = NO;
    self.selectButton = sender;
    [UIView animateWithDuration:0.4 animations:^{
        self.indicatorView.width = sender.width;
        self.indicatorView.x = sender.x;
    }];
    //让UIScrollView滚动到对应位置
    CGPoint offset = self.scrollView.contentOffset;
    offset.x = sender.tag * self.scrollView.width;
    [self.scrollView setContentOffset:offset animated:YES];
}
// 设置底部的scrollView
- (void)setUpScrollView{
    //不要自动调整inset
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.scrollView = [[UIScrollView alloc]init];
    self.scrollView.frame = self.view.bounds;
    self.scrollView.delegate = self;
    self.scrollView.pagingEnabled = YES;
    [self.view insertSubview:self.scrollView atIndex:0];
    self.scrollView.contentSize = CGSizeMake(self.scrollView.width * self.childViewControllers.count, 0);
    //添加第一个控制器的view
    [self scrollViewDidEndScrollingAnimation:self.scrollView];
    
}

#pragma mark - 添加子控制器的view
- (void)addChildVcView{
    // 子控制器的索引
    NSUInteger index = self.scrollView.contentOffset.x / self.scrollView.width;
    // 取出子控制器
    UIViewController *childVc = self.childViewControllers[index];
    if ([childVc isViewLoaded]) return;
    childVc.view.frame = self.scrollView.bounds;
    [self.scrollView addSubview:childVc.view];
}


//初始化子控制器
- (void)setUpChildViewController{
    
    CCHeadLineViewController * collection = [[CCHeadLineViewController alloc]init];
    [self addChildViewController:collection];
    
    CCinformationViewController * highlights = [[CCinformationViewController alloc]init];
    [self addChildViewController:highlights];
    
    
    
}


#pragma mark - <UIScrollViewDelegate>
/**
 * 在scrollView滚动动画结束时, 就会调用这个方法
 * 前提: 使用setContentOffset:animated:或者scrollRectVisible:animated:方法让scrollView产生滚动动画
 */
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView{
    
    [self addChildVcView];
}
/**
 * 在scrollView滚动动画结束时, 就会调用这个方法
 * 前提: 人为拖拽scrollView产生的滚动动画
 */
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    [self scrollViewDidEndScrollingAnimation:scrollView];
    //点击按钮
    NSInteger index = scrollView.contentOffset.x / scrollView.width;
    [self tilteClick:self.titleView.subviews[index]];
    // 添加子控制器的view
    [self addChildVcView];
}














@end
