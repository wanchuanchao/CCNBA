//
//  CCFullViewController.m
//  nba
//
//  Created by lanou3g on 16/7/21.
//  Copyright © 2016年 wanccao. All rights reserved.
//

#import "CCFullViewController.h"

@interface CCFullViewController ()<CCPlayerViewDelegate>

@end

@implementation CCFullViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    [self.view addSubview:self.playerView];
    self.playerView.delegate = self;
    self.navigationController.navigationBarHidden = YES;
    //supportedInterfaceOrientations
    //    横屏
    if (self.view.frame.size.width > self.view.frame.size.height) {
        self.playerView.frame = CGRectMake(0,0,HEIGHT,WIDTH);
        
    }
    //    竖屏
    if (self.view.frame.size.width < self.view.frame.size.height) {
        self.playerView.frame = CGRectMake(0,0,WIDTH,HEIGHT);
    }

}

-(void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator{
    //    横屏
    if (size.width > size.height) {
        self.playerView.frame = CGRectMake(0,0,HEIGHT,WIDTH);
        
    }
    //    竖屏
    if (size.width < size.height) {
        self.playerView.frame = CGRectMake(0,0,HEIGHT,WIDTH);
    }
}

- (void)notFullPlay{
    [self.navigationController popViewControllerAnimated:YES];
}


-(BOOL)shouldAutorotate{
    return NO;
}


// 支持很竖屏
-(UIInterfaceOrientationMask)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskAll;
}


@end
