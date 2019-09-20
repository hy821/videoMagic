//
//  LoginViewController.h
//  MagicVideo
//
//  Created by young He on 2019/9/18.
//  Copyright © 2019年 youngHe. All rights reserved.
//

#import "KSBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface LoginViewController : KSBaseViewController

@property (nonatomic,strong) UIViewController *vcFrom;

//微信登录成功, 绑定手机号
@property (nonatomic,assign) BOOL isBindPhone;  //push进来

@end

NS_ASSUME_NONNULL_END
