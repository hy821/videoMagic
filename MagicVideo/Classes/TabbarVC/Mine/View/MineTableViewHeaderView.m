//
//  MineTableViewHeaderView.m
//  KSMovie
//
//  Created by young He on 2018/9/14.
//  Copyright © 2018年 youngHe. All rights reserved.
//

#import "MineTableViewHeaderView.h"
#import "UILabel+Category.h"
#import "UIButton+Category.h"
#import "HorizenButton.h"

@interface MineTableViewHeaderView ()
@property (nonatomic,weak) UIImageView *bgIV;
@property (nonatomic,weak) UIImageView *iconIV;
@property (nonatomic,weak) UILabel *nameLab;
@property (nonatomic,weak) UIButton *setBtn;
@end

@implementation MineTableViewHeaderView

- (void)refresh {
    if ([USER_MANAGER getUserIcon].length>0) {
        [self.iconIV sd_setImageWithURL:URL([USER_MANAGER getUserIcon]) placeholderImage:img_placeHolderIcon options:SDWebImageRetryFailed];
    }else {
        self.iconIV.image = img_placeHolderIcon;
    }
    
    if ([USER_MANAGER getUserNickName].length>0) {
        self.nameLab.text = [USER_MANAGER getUserNickName];
    }else {
        self.nameLab.text = @"点击登录";
    }
    
    
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self= [super initWithFrame:frame]) {
        [self createUI];
    }return self;
}

- (void)createUI {
    self.backgroundColor = White_Color;
    
    UIImageView *iv = [[UIImageView alloc]init];
    iv.image = Image_Named(@"img_user_bg");
    iv.userInteractionEnabled = YES;
    [self addSubview:iv];
    self.bgIV = iv;
    [self.bgIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
    UIImageView *iconIV = [[UIImageView alloc]init];
    iconIV.layer.masksToBounds = YES;
    iconIV.contentMode = UIViewContentModeScaleAspectFill;
    if ([USER_MANAGER getUserIcon].length>0) {
        [iconIV sd_setImageWithURL:URL([USER_MANAGER getUserIcon]) placeholderImage:img_placeHolderIcon options:SDWebImageRetryFailed];
    }else {
        iconIV.image = img_placeHolderIcon;
    }
    
    iconIV.userInteractionEnabled = YES;
    [self.bgIV addSubview:iconIV];
    self.iconIV = iconIV;
    self.iconIV.layer.cornerRadius = self.sizeH(35);
    self.iconIV.layer.borderColor = White_Color.CGColor;
    self.iconIV.layer.borderWidth = self.sizeH(4);
    [self.iconIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.bgIV);
        make.width.height.equalTo(self.sizeH(70));
    }];
    
    UILabel *lab = [UILabel labelWithTitle:@"" font:17 textColor:White_Color textAlignment:1];
    lab.userInteractionEnabled = YES;
    if ([USER_MANAGER getUserNickName].length>0) {
        lab.text = [USER_MANAGER getUserNickName];
    }else {
        lab.text = @"点击登录";
    }
    [self.bgIV addSubview:lab];
    self.nameLab = lab;
    [self.nameLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.iconIV.mas_bottom).offset(self.sizeH(10));
        make.centerX.equalTo(self.iconIV);
    }];
    
    UIButton *btn = [UIButton buttonWithImage:Image_Named(@"ic_setting") selectedImage:Image_Named(@"ic_setting")];
    [btn addTarget:self action:@selector(setAction) forControlEvents:UIControlEventTouchUpInside];
    [self.bgIV addSubview:btn];
    self.setBtn = btn;
    [self.setBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bgIV).offset([self contentOffset]-30);
        make.right.equalTo(self.bgIV).offset(self.sizeH(-20));
    }];
    
 
    UITapGestureRecognizer *gesture1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    [self.nameLab addGestureRecognizer:gesture1];
    UITapGestureRecognizer *gesture2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    [self.iconIV addGestureRecognizer:gesture2];
}

- (void)handleTap:(UITapGestureRecognizer *)gesture {
    if (self.modifyMsgBlock) {
        self.modifyMsgBlock();
    }
}

- (void)setAction {
//    SettingViewController *vc = [[SettingViewController alloc]init];
//    vc.hidesBottomBarWhenPushed = YES;
//    [SelectVC pushViewController:vc animated:YES];
}

@end
