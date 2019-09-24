//
//  WalletHeaderView.h
//  MagicVideo
//
//  Created by young He on 2019/9/24.
//  Copyright © 2019年 youngHe. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface WalletHeaderView : UIView

@property (nonatomic,copy) void(^withdrawBlock)(void);
@property (nonatomic,copy) void(^getGoldBlock)(void);
@property (nonatomic,copy) void(^barBtnClickBlock)(BOOL isRed);
@property (nonatomic,copy) void(^tipShowBlock)(BOOL isWithdraw); //提现规则or金币规则

@end

NS_ASSUME_NONNULL_END
