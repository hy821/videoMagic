//
//  VideoRecomCell.h
//  MagicVideo
//
//  Created by young He on 2019/9/24.
//  Copyright © 2019年 youngHe. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface VideoRecomCell : UITableViewCell

+(instancetype)cellForTableView:(UITableView*)tableView;

@property (nonatomic,strong) NSIndexPath *indexPath;

@end

NS_ASSUME_NONNULL_END
