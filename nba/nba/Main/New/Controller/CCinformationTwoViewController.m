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
#import <UMSocial.h>
#import "CCInformationModel.h"
@interface CCinformationTwoViewController ()<UIWebViewDelegate,UMSocialUIDelegate>

/**   */
@property (nonatomic,strong) MBProgressHUD *hud;
/**   */
@property (nonatomic,strong) UIWebView *webView;
/**   */
@property (nonatomic,strong) CCInformationModel *model;


@end

@implementation CCinformationTwoViewController


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.tabBarController.tabBar.hidden = NO;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
<<<<<<< HEAD
    self.webView = [[UIWebView alloc] initWithFrame:self.view.frame];
=======
    self.webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 50)];
>>>>>>> ee0e24bfde32fa3ef339370bf76861ab60f660af
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.url]]];
    self.webView.delegate = self;
    [self NetworkMonitoring];
    [self setNavBtn];
    
    
}

- (void)NetworkMonitoring {
    
}

#pragma mark UIWebView的代理方法
- (void)webViewDidStartLoad:(UIWebView *)webView {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    AFNetworkReachabilityManager *mgr = [AFNetworkReachabilityManager sharedManager];
    [mgr startMonitoring];
    [mgr setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        if (status == AFNetworkReachabilityStatusNotReachable) {
            self.hud.mode = MBProgressHUDModeText;
            self.hud.labelText = @"当前无网络";
        }
    }];
//    [self.hud hide:YES afterDelay:2];
//    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    
    
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
//    NSString *str = [NSString stringWithFormat:@"http://sportsnba.qq.com/news/item?appver=1.0.2&appvid=1.0.2&articleIds=%@&column=news&deviceId=CA0D1337-38E7-441E-9611-26B9FAAA6272&from=app&guid=CA0D1337-38E7-441E-9611-26B9FAAA6272&height=667&network=WiFi&os=iphone&osvid=9.3.2&width=375",self.url];
    [webView stringByEvaluatingJavaScriptFromString:@"var div = document.getElementsByClassName('share')[0];div.parentElement.removeChild(div);var div1 = document.getElementsByTagName('header')[0];div1.parentElement.removeChild(div1);var div2 = document.getElementsByClassName('app-layer')[0];div2.parentElement.removeChild(div2);var div3 = document.getElementsByClassName('navbar')[0];div3.parentElement.removeChild(div3);var div4 = document.getElementsByTagName('footer')[0];div4.parentElement.removeChild(div4);var div5 = document.getElementsByClassName('xw-for-nba-qrcode')[0];div5.parentElement.removeChild(div5);var div6 = document.getElementsByClassName('xw-for-nba-logo')[0];div6.parentElement.removeChild(div6);var div7 = document.getElementsByClassName('count')[0];div7.parentElement.removeChild(div7);var div8 = document.getElementsByClassName('comments')[0];div8.parentElement.removeChild(div8)"];
        [self.view addSubview:webView];
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(nullable NSError *)error {
    if (error) {
        NSLog(@"---------%@",error);
    }
}


// 点击分享
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
