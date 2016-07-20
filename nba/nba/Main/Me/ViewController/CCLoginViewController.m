//
//  CCLoginViewController.m
//  nba
//
//  Created by lanou3g on 16/7/14.
//  Copyright © 2016年 wanccao. All rights reserved.
//

#import "CCLoginViewController.h"
#import "UMSocial.h"

#import "NSString+alertView.h"
#import "CCHeadLineViewController.h"

#import "CCUserModel.h"
#import "CCDataBasehandle.h"
#import "MBProgressHUD.h"

#define CDataBasehandle [CCDataBasehandle sharedDataBasehandle]
@interface CCLoginViewController ()
/** 登录框距离控制器View左边的间距 */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *loginViewLeftmargin;

@property (weak, nonatomic) IBOutlet UITextField *loginUserNameTF;
@property (weak, nonatomic) IBOutlet UITextField *loginPasswordTF;
@property (weak, nonatomic) IBOutlet UITextField *registUserNameTF;
@property (weak, nonatomic) IBOutlet UITextField *registPasswordTF;
@property (nonatomic,strong) UIBarButtonItem *itemBtn;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;

@end

@implementation CCLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // 添加注册按钮
    [self addNavigationItem];
    // 键盘处理
    [self revocationKeyboard];
    // 建表
    [CDataBasehandle createtableName:@"CCUserModel" Modelclass:[CCUserModel class]];
    
    
}
// 键盘处理
-(void)revocationKeyboard{
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closeKeyboard:)];
    tap.numberOfTapsRequired = 1;
    tap.numberOfTouchesRequired = 1;
    [self.view addGestureRecognizer:tap];
//    [self.loginButton addGestureRecognizer:tap];
    
}

- (void)closeKeyboard:(id)sender
{
    [self.view endEditing:YES];
}

// 添加注册按钮
- (void)addNavigationItem{
    UIBarButtonItem *rightBtn=[[UIBarButtonItem alloc]initWithTitle:@"注册账号" style:UIBarButtonItemStylePlain target:self action:@selector(rightBtnAction:)];
    self.navigationItem.rightBarButtonItem=rightBtn;
    self.itemBtn = rightBtn;
    
}
// 注册按钮点击事件
- (void)rightBtnAction:(UIBarButtonItem *)itemBtn{
    
    if (self.loginViewLeftmargin.constant == 0) { //注册界面
         self.loginViewLeftmargin.constant = - self.view.width;
        [itemBtn setTitle:@"已有账号"];
    }else{ // 登录界面
        self.loginViewLeftmargin.constant = 0;
        [itemBtn setTitle:@"注册账号"];
    }
    
        [UIView animateWithDuration:0.25 animations:^{
        [self.view layoutIfNeeded];
    }];
}

// 登录
- (IBAction)loginAction:(UIButton *)sender {
   CCUserModel *model = [[CCUserModel alloc]init];
    NSArray *arr = [CDataBasehandle selectFromAttributeName:@"name" ValueStr:self.loginUserNameTF.text];
    for (model in arr) {
        if (model.name != self.loginUserNameTF.text) {
            [NSString alterString:@"用户不存在"];
        }else{
            if (model.passwrod != self.loginPasswordTF.text) {
                [NSString alterString:@"密码错误"];
            } else {
                [UIView animateWithDuration:0.7 animations:^{
                [self.navigationController popViewControllerAnimated:YES];
                }];
               
            }
        }
    }
    
}

// 注册
- (IBAction)registAction:(UIButton *)sender {
    NSArray *arr = [CDataBasehandle selectAllModel];
    if (arr.count == 0) {
        CCUserModel *model = [[CCUserModel alloc]init];
        model.name = self.registUserNameTF.text;
        model.passwrod = self.registPasswordTF.text;
        [CDataBasehandle insertIntoTableModel:model];
        self.loginViewLeftmargin.constant = 0;
        [self.itemBtn setTitle:@"注册账号"];
        [NSString alterString:@"注册成功"];
    }else{
        NSMutableArray *array = [NSMutableArray array];
        for (CCUserModel *model in arr) {
            [array addObject:model.name];
        }
        if ([array containsObject:self.registUserNameTF.text]) {
            [NSString alterString:@"用户名已存在"];
        } else {
            CCUserModel *model = [[CCUserModel alloc]init];
            model.name = self.registUserNameTF.text;
            model.passwrod = self.registPasswordTF.text;
            [CDataBasehandle insertIntoTableModel:model];
            self.loginViewLeftmargin.constant = 0;
            [self.itemBtn setTitle:@"注册账号"];
            [NSString alterString:@"注册成功"];
        }
    }
    
}



// 第三方授权登录
- (IBAction)loginButtonAction {
    UMSocialSnsPlatform *snsPlatform = [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToQQ];
    
    snsPlatform.loginClickHandler(self,[UMSocialControllerService defaultControllerService],YES,^(UMSocialResponseEntity *response){
        // 获取微博用户名、uid、token等
        if (response.responseCode == UMSResponseCodeSuccess) {
            UMSocialAccountEntity *snsAccount = [[UMSocialAccountManager socialAccountDictionary] valueForKey:UMShareToQQ];
            NSLog(@"\nusername = %@,\n usid = %@,\n token = %@ iconUrl = %@,\n ",snsAccount.userName,snsAccount.usid,snsAccount.accessToken,snsAccount.iconURL);
        }});
}



@end
