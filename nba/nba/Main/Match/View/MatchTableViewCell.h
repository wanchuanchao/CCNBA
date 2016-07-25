//
//  MatchTableViewCell.h
//  nba
//
//  Created by lanou3g on 16/7/8.
//  Copyright © 2016年 wanccao. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MatchModel;
@class MatchTableViewCell;
@protocol MatchTableViewCellDelegate <NSObject>
- (void)tapTableViewCell:(MatchTableViewCell *)tableViewCell withType:(NSString *)type mid:(NSString *)mid title:(NSString *)title;
@end
@interface MatchTableViewCell : UITableViewCell
@property(nonatomic,weak)id<MatchTableViewCellDelegate>delegate;
@property (nonatomic,strong)MatchModel *model;    
@end
