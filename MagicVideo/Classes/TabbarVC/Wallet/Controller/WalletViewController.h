//
//  WalletViewController.h
//  MagicVideo
//
//  Created by young He on 2019/9/18.
//  Copyright © 2019年 youngHe. All rights reserved.
//

#import "KSBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface WalletViewController : KSBaseViewController

@end

@interface WalletUnLoginView : UIView

@property (nonatomic,copy) void(^loginBlock)(void);

@end

NS_ASSUME_NONNULL_END
