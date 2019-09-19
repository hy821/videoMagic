//
//  SSphotoListCell.h
//  SmallStuff
//
//  Created by 闵玉辉 on 17/4/16.
//  Copyright © 2017年 yuhuimin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TZImageManager.h"
@interface SSphotoListCell : UITableViewCell
+(instancetype)cellForTableView:(UITableView*)tableView;
@property (nonatomic, strong) TZAlbumModel *model;
@end
