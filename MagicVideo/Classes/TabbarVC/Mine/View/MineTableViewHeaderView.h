//
//  MineTableViewHeaderView.h
//  KSMovie
//
//  Created by young He on 2018/9/14.
//  Copyright © 2018年 youngHe. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MineTableViewHeaderView : UIView

@property (nonatomic,copy) void(^modifyMsgBlock)(void);
- (void)refresh;

@end
