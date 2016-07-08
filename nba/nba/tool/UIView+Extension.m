//
//  UIView+Extension.m
//  加速计
//
//  Created by lanou3g on 16/7/6.
//  Copyright © 2016年 wanccao. All rights reserved.
//

#import "UIView+Extension.h"

@implementation UIView (Extension)
- (float)x {
    return self.frame.origin.x;
}


- (float)y {
    return self.frame.origin.y;
}

- (void)setX:(float)x {
    CGRect rect = CGRectMake(x, self.frame.origin.y, self.frame.size.width, self.frame.size.height);
    self.frame = rect;
}

- (void)setY:(float)y {
    CGRect rect = CGRectMake(self.frame.origin.x, y, self.frame.size.width, self.frame.size.height);
    self.frame = rect;
}


- (void)setHeight:(float)height {
    CGRect rect = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, height);
    self.frame = rect;
}

- (float)height {
    return self.frame.size.height;
}


- (void)setWidth:(float)width {
    CGRect rect = CGRectMake(self.frame.origin.x, self.frame.origin.y, width, self.frame.size.height);
    self.frame = rect;
}

- (float)width {
    return self.frame.size.width;
}


- (float)maxX {
    return CGRectGetMaxX(self.frame);
}

- (void)setMaxX:(float)maxX {
    self.frame = CGRectMake(maxX - self.width, self.frame.origin.y, self.width, self.height);
}

- (float)maxY {
    return CGRectGetMaxY(self.frame);
}

- (void)setMaxY:(float)maxY {
    self.frame = CGRectMake(self.x, maxY - self.height, self.width, self.height);
}
@end
