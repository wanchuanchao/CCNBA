//
//  CCCalendarCollectionViewCell.m
//  nba
//
//  Created by lanou3g on 16/7/19.
//  Copyright © 2016年 wanccao. All rights reserved.
//

#import "CCCalendarCollectionViewCell.h"

@implementation CCCalendarCollectionViewCell
- (UILabel *)dateLabel
{
    if (!_dateLabel) {
        _dateLabel = [[UILabel alloc] initWithFrame:self.bounds];
        [_dateLabel setTextAlignment:NSTextAlignmentCenter];
        [_dateLabel setFont:[UIFont systemFontOfSize:17]];
        [self addSubview:_dateLabel];
    }
    return _dateLabel;
}
- (void)awakeFromNib {
    
    
}

@end
