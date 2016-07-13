//
//  CCHeadTwoViewController.m
//  nba
//
//  Created by lanou3g on 16/7/12.
//  Copyright © 2016年 wanccao. All rights reserved.
//

#import "CCHeadTwoViewController.h"
#import <MBProgressHUD.h>
@interface CCHeadTwoViewController ()<UIWebViewDelegate>

/**  蒙板 */
@property (nonatomic,strong) MBProgressHUD *hud;
/**   */
@property (nonatomic,strong) UIWebView *webView;
@end

@implementation CCHeadTwoViewController


- (void)webViewDidStartLoad:(UIWebView *)webView {
//    self.hud = [[MBProgressHUD alloc] init];
//    [self.hud show:YES];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
}
- (void)webViewDidFinishLoad:(UIWebView *)webView {
//    self.hud = [[MBProgressHUD alloc] init];
//    [self.hud hide:YES afterDelay:2];
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(nullable NSError *)error {
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    if (error) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"系统提示" message:@"网络状况不良" preferredStyle:(UIAlertControllerStyleAlert)];
        UIAlertAction *did = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
        [alert addAction:did];
        [self presentViewController:alert animated:YES completion:nil];
        NSLog(@"as");
    }
    
    
    
}



- (void)viewDidLoad {
    [super viewDidLoad];
    self.webView = [[UIWebView alloc] initWithFrame:self.view.frame];
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.url]]];
    self.webView.delegate = self;
    [self.view addSubview:self.webView];
    
     
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
