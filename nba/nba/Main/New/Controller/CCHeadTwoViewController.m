//
//  CCHeadTwoViewController.m
//  nba
//
//  Created by lanou3g on 16/7/12.
//  Copyright © 2016年 wanccao. All rights reserved.
//

#import "CCHeadTwoViewController.h"
#import <MBProgressHUD.h>
#import <AFNetworking.h>
#import <UMSocial.h>
#import "CCInformationModel.h"
@interface CCHeadTwoViewController ()<UIWebViewDelegate,UMSocialUIDelegate>

/**  蒙板 */
@property (nonatomic,strong) MBProgressHUD *hud;
/**   */
@property (nonatomic,strong) UIWebView *webView;
/**   */
@property (nonatomic,strong) CCInformationModel *model;
@end

@implementation CCHeadTwoViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.tabBarController.tabBar setHidden:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self setNavBtn];
    
    self.webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 50)];
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.url]]];
    self.webView.delegate = self;
    
    
    AFNetworkReachabilityManager *mgr = [AFNetworkReachabilityManager sharedManager];
    [mgr setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        if (status == AFNetworkReachabilityStatusNotReachable) {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"系统提示" message:@"网络链接失败,请检查网络是否链接正常" preferredStyle:(UIAlertControllerStyleAlert)];
                    UIAlertAction *did = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
                    [alert addAction:did];
        }
    }];
     
}


- (void)webViewDidStartLoad:(UIWebView *)webView {
    
    self.hud = [[MBProgressHUD alloc] initWithView:self.view];
    AFNetworkReachabilityManager *mgr = [AFNetworkReachabilityManager sharedManager];
    [mgr startMonitoring];
    [mgr setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        if (status == AFNetworkReachabilityStatusNotReachable) {
            self.hud.mode = MBProgressHUDModeText;
            self.hud.labelText = @"当前无网络";
        }
    }];
    [self.view addSubview:self.hud];
    [self.hud show:YES];
    [self.hud hide:YES afterDelay:2];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    self.webView = webView;
    [self.webView stringByEvaluatingJavaScriptFromString:@"var div = document.getElementsByClassName('share')[0];div.parentElement.removeChild(div);var div1 = document.getElementsByTagName('header')[0];div1.parentElement.removeChild(div1);var div2 = document.getElementsByClassName('app-layer')[0];div2.parentElement.removeChild(div2);var div3 = document.getElementsByClassName('navbar')[0];div3.parentElement.removeChild(div3);var div4 = document.getElementsByTagName('footer')[0];div4.parentElement.removeChild(div4);var div5 = document.getElementsByClassName('xw-for-nba-qrcode')[0];div5.parentElement.removeChild(div5);var div6 = document.getElementsByClassName('xw-for-nba-logo')[0];div6.parentElement.removeChild(div6);var div7 = document.getElementsByClassName('count')[0];div7.parentElement.removeChild(div7);var div8 = document.getElementsByClassName('comments')[0];div8.parentElement.removeChild(div8)"];
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    [self.view addSubview:self.webView];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(nullable NSError *)error {
    
}



// 添加分享
- (void)setNavBtn {
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"mainCellShare"] style:(UIBarButtonItemStylePlain) target:self action:@selector(navBtnAction)];
}


- (void)navBtnAction {
    [UMSocialData defaultData].extConfig.title = self.model.title;
    [UMSocialData defaultData].extConfig.qqData.url = @"http://baidu.com";
    
    [UMSocialSnsService presentSnsIconSheetView:self
                                         appKey:@"5788e997e0f55aab37001bfc"
                                      shareText:self.url
                                     shareImage:[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:self.model.imgurl2]]]
                                shareToSnsNames:@[UMShareToWechatSession,UMShareToWechatTimeline,UMShareToQQ,UMShareToQzone,UMShareToSina]
                                       delegate:self];
}




@end
