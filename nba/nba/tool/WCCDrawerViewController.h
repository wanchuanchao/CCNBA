//
//  WCCDrawerViewController.h
//  封装抽屉
//
//  Created by lanou3g on 16/7/1.
//  Copyright © 2016年 wanccao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WCCDrawerViewController : UIViewController
@property (nonatomic,strong)NSString *btnImage;   //按钮图片
- (instancetype)initWithRootViewController:(UIViewController *)rootViewController menuViewController:(UIViewController *)menuViewController;
- (void)showRootViewController;
-(void)showMenuViewController;
- (void)showViewController:(UIViewController *)vc;
@end
