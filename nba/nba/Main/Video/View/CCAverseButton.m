//
//  CCAverseButton.m
//  nba
//
//  Created by lanou3g on 16/7/18.
//  Copyright © 2016年 wanccao. All rights reserved.
//

#import "CCAverseButton.h"
#import "UIView+Extension.h"

@implementation CCAverseButton

-(void)awakeFromNib{
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
}


-(void)layoutSubviews{
    [super layoutSubviews];
    // 设置图片
    self.imageView.x = 0;
    self.imageView.y = 0;
    self.imageView.width = self.width;
    self.imageView.height = self.imageView.width;
    
    // 设置文字
    self.titleLabel.x = 0;
    self.titleLabel.y = self.imageView.height;
    self.titleLabel.width = self.width;
    self.titleLabel.height = self.height - self.titleLabel.y;
}

@end
