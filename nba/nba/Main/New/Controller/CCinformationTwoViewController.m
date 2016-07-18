//
//  CCinformationTwoViewController.m
//  nba
//
//  Created by lanou3g on 16/7/18.
//  Copyright © 2016年 wanccao. All rights reserved.
//

#import "CCinformationTwoViewController.h"
#import <MBProgressHUD.h>
#import <AFNetworking.h>
@interface CCinformationTwoViewController ()<UIWebViewDelegate>

/**   */
@property (nonatomic,strong) MBProgressHUD *hud;
/**   */
@property (nonatomic,strong) UIWebView *webView;
@end

@implementation CCinformationTwoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.webView = [[UIWebView alloc] initWithFrame:self.view.frame];
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.url]]];
    self.webView.delegate = self;
    [self.view addSubview:self.webView];
    [self NetworkMonitoring];
}

- (void)NetworkMonitoring {
    AFNetworkReachabilityManager *mgr = [AFNetworkReachabilityManager sharedManager];
    [mgr startMonitoring];
    [mgr setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        NSString *result = @"";
        switch (status) {
            case AFNetworkReachabilityStatusUnknown:
                result = @"位置网络";
                break;
            case AFNetworkReachabilityStatusNotReachable:
                result = @"无网络";
                break;
            case AFNetworkReachabilityStatusReachableViaWWAN:
                result = @"数据流量";
                break;
            case AFNetworkReachabilityStatusReachableViaWiFi:
                result = @"WIFI";
                
                break;
                
            default:
                break;
        }
        NSLog(@"%@",result);
    }];
}

#pragma mark UIWebView的代理方法
- (void)webViewDidStartLoad:(UIWebView *)webView {
    self.hud = [[MBProgressHUD alloc] initWithView:self.view];
    self.hud.labelText = @"wifi";
    self.hud.mode = MBProgressHUDModeText;
    [self.view addSubview:self.hud];
    [self.hud show:YES];
//    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(nullable NSError *)error {
    if (error) {
        NSLog(@"---------%@",error);
    }
}


- (void)setNavBtn {
    UIBarButtonItem *btn = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"mainCellShare"] style:(UIBarButtonItemStyleDone) target:self action:@selector(navBtnAction)];
    self.navigationItem.rightBarButtonItem = btn;
}


- (void)navBtnAction {
    
}

@end
