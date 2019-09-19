//
//  MineTableViewCell.h
//  KSMovie
//
//  Created by young He on 2018/9/14.
//  Copyright © 2018年 youngHe. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MineTableViewCell : UITableViewCell

+(instancetype)cellForTableView:(UITableView*)tableView;
@property (nonatomic,strong) MineTVCellModel *model;

@end
