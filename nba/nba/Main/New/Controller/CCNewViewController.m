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

/**  导航栏图标 */
@property (nonatomic,strong) UIButton *navBtn;
/**  头条控制器 */
@property (nonatomic,strong) CCHeadLineViewController *headLineVC;
/**  资讯控制器 */
@property (nonatomic,strong) CCinformationViewController *informationVC;

@end

@implementation CCNewViewController

- (void)viewDidLoad {
    
    
//    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"图标" style:(UIBarButtonItemStylePlain) target:self action:nil];
    [super viewDidLoad];
    [self setSegment];
    [self setChildViewController];
}

- (void)setSegment {
    self.view.backgroundColor = [UIColor orangeColor];
    UISegmentedControl *segment = [[UISegmentedControl alloc] initWithItems:@[@"头条",@"资讯"]];
    segment.frame = CGRectMake(0, 0,150, 30);
    segment.layer.borderWidth = 0.0;
    //    segment.tintColor = [UIColor whiteColor];
//    segment.segmentedControlStyle = UISegmentedControlStyleBar;
    segment.backgroundColor = [UIColor whiteColor];
    segment.selectedSegmentIndex = 0;
    [segment addTarget:self action:@selector(selectedSegmentIndexAction:) forControlEvents:(UIControlEventValueChanged)];
    self.navigationItem.titleView = segment;
}

// 设置子控制器
- (void)setChildViewController {
    self.headLineVC = [[CCHeadLineViewController alloc] init];
    [self.view addSubview:self.headLineVC.view];
    //self.headLineVC.view.frame = self.view.bounds;
    [self addChildViewController:self.headLineVC];
//    self.informationVC = [[CCinformationViewController alloc] init];
//    [self.view addSubview:self.informationVC.view];
//     self.informationVC.view.frame = self.view.bounds;
//    [self addChildViewController:_informationVC];
    
}

//- (void)selectedSegmentIndexAction:(UISegmentedControl *)tag {
//    NSInteger index = tag.selectedSegmentIndex;
//    if (index == 0) {
//        
//    }
//}

- (void)selectedSegmentIndexAction:(id)sender {
    switch ([(UISegmentedControl *)sender selectedSegmentIndex]) {
        case 0:{
            
            if (!_headLineVC) {
               self.headLineVC = [[CCHeadLineViewController alloc] init];
            }
            
            NSLog(@"");
            NSArray *array1 = [self.view subviews];
            if ([array1 count] == 2) {
                [[array1 objectAtIndex:1] removeFromSuperview];
            }
           
            [self.view addSubview:self.headLineVC.view];
            break;
        }
        case 1:{
            if (!_informationVC) {
                self.informationVC = [[CCinformationViewController alloc] init];
            }
            NSLog(@"");
            NSArray *array2 = [self.view subviews];
            if ([array2 count] == 2) {
                [[array2 objectAtIndex:1] removeFromSuperview];
            }
            
            [self.view addSubview:self.informationVC.view];
            break;
        }
        default:
        {
            NSLog(@"ccc");
            break;
        }
    }
    
}

// 添加平移手势
- (void)addPan {
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panAction:)];
    [self.view addGestureRecognizer:pan];
}

- (void)panAction:(UIPanGestureRecognizer *)sender {
    CGPoint translation = [sender translationInView:self.view];
    CGPoint center = sender.view.center;
    center.x += translation.x;
    center.y += translation.y;
    sender.view.center = center;
    //    清空移动距离
    [sender setTranslation:CGPointZero inView:sender.view];
}
















@end
