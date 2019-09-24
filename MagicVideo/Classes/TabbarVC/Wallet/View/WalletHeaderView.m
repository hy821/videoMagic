//
//  WalletHeaderView.m
//  MagicVideo
//
//  Created by young He on 2019/9/24.
//  Copyright © 2019年 youngHe. All rights reserved.
//

#import "WalletHeaderView.h"
#import "UILabel+Category.h"
#import "VerticalButton.h"
#import "UIButton+Category.h"

@interface WalletHeaderView ()

@property (nonatomic,weak) UILabel *nickNameLab;
@property (nonatomic,weak) UIButton *redBarBtn;
@property (nonatomic,weak) UIButton *withdrawBarBtn;

@property (nonatomic,weak) UILabel *goldLab;
@property (nonatomic,weak) UILabel *moneyLab;

@end

@implementation WalletHeaderView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self= [super initWithFrame:frame]) {
        [self createUI];
    }return self;
}

- (void)createUI {
    self.backgroundColor = White_Color;

    UIImageView *bg = [[UIImageView alloc]init];
    bg.contentMode = UIViewContentModeScaleAspectFit;
    bg.image = Image_Named(@"walletBg");
    [self addSubview:bg];
    [bg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self);
    }];

    NSString *nameStr = [NSString stringWithFormat:@"%@  的",[USER_MANAGER getUserNickName]];
    UILabel *nickNameLab = [UILabel labelWithTitle:nameStr font:14 textColor:White_Color textAlignment:1];
    [self addSubview:nickNameLab];
    self.nickNameLab = nickNameLab;
    [self.nickNameLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset([self contentOffset]*2/3);
        make.left.equalTo(self).offset(self.sizeW(16));
    }];
    
    UILabel *walletLab = [UILabel labelWithTitle:@"个人钱包" font:30 textColor:White_Color textAlignment:0];
    walletLab.font = Font_Bold(30);
    [self addSubview:walletLab];
    [walletLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.nickNameLab.mas_bottom).offset(self.sizeW(10));
        make.left.equalTo(self.nickNameLab);
    }];
    
    VerticalButton *withdrawBtn = [[VerticalButton alloc]init];
    withdrawBtn.verticalMarge = 6.f;
    withdrawBtn.layer.masksToBounds = YES;
    withdrawBtn.layer.cornerRadius = self.sizeH(3);
    [withdrawBtn setTitle:@"提现" forState:UIControlStateNormal];
    [withdrawBtn setTitleColor:White_Color forState:UIControlStateNormal];
    [withdrawBtn setTitleColor:White_Color forState:UIControlStateSelected];
    [withdrawBtn setImage:Image_Named(@"walletWithdraw") forState:UIControlStateNormal];
    [withdrawBtn setImage:Image_Named(@"walletWithdraw") forState:UIControlStateSelected];
    withdrawBtn.titleLabel.font = Font_Size(12);
    [withdrawBtn addTarget:self action:@selector(withdrawAction) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:withdrawBtn];
    [withdrawBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).offset(self.sizeW(-20));
        make.top.equalTo(nickNameLab.mas_bottom).offset(-10);
        make.height.equalTo(50);
        make.width.equalTo(40);
    }];
    
    UIButton *tipBtn = [UIButton buttonWithImage:Image_Named(@"walletWithdraw_tip") selectedImage:Image_Named(@"walletWithdraw_tip")];
    tipBtn.tag = 100;
    [tipBtn addTarget:self action:@selector(tipBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:tipBtn];
    [tipBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(withdrawBtn).offset(-3);
        make.left.equalTo(withdrawBtn.mas_right);
        make.height.equalTo(20);
    }];
    
    //----->>> CardView
    CGFloat barHeight = self.sizeW(50);
    UIView *cardBgView = [[UIView alloc]init];
    cardBgView.backgroundColor = White_Color;
    cardBgView.alpha = 0.85;
//    cardBgView.layer.masksToBounds = YES;  //会影响阴影效果
    cardBgView.layer.cornerRadius = self.sizeW(8);
    cardBgView.layer.shadowColor = Black_Color.CGColor;
    cardBgView.layer.shadowOffset = CGSizeMake(2,6);
    cardBgView.layer.shadowOpacity = 0.5;
    cardBgView.layer.shadowRadius = 8;
    
    [self addSubview:cardBgView];
    [cardBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(walletLab.mas_bottom).offset(12);
        make.left.equalTo(self).offset(self.sizeW(15));
        make.right.equalTo(self).offset(self.sizeW(-15));
        make.bottom.equalTo(self).offset(-(barHeight+10));
    }];
    //------>>> In CardView
    UIButton *getGoldBtn = [UIButton buttonWithTitle:@"赚金币" titleColor:White_Color bgColor:KCOLOR(@"#FFA500") highlightedColor:White_Color];
    [getGoldBtn.titleLabel setFont:Font_Size(18)];
    getGoldBtn.layer.masksToBounds = YES;
    getGoldBtn.layer.cornerRadius = self.sizeW(6);
    [self addSubview:getGoldBtn];
    [getGoldBtn addTarget:self action:@selector(getGoldAction) forControlEvents:UIControlEventTouchUpInside];
    [getGoldBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(cardBgView.mas_centerY).offset(self.sizeW(18));
        make.width.equalTo(ScreenWidth*2/3);
        make.height.equalTo(self.sizeW(48));
        make.centerX.equalTo(cardBgView);
    }];
    //constant Lab 金币数 红包金额  &  tipBtn
    UILabel *constGoldLab = [UILabel labelWithTitle:@"金币数" font:17 textColor:LightGray_Color textAlignment:1];
    [self addSubview:constGoldLab];
    [constGoldLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(cardBgView.mas_centerY).offset(self.sizeW(0));
        make.right.equalTo(cardBgView.mas_centerX);
        make.width.equalTo(ScreenWidth/3);
    }];
    UILabel *constMoneyLab = [UILabel labelWithTitle:@"红包金额" font:17 textColor:LightGray_Color textAlignment:1];
    [self addSubview:constMoneyLab];
    [constMoneyLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(cardBgView.mas_centerY).offset(self.sizeW(0));
        make.left.equalTo(cardBgView.mas_centerX);
        make.width.equalTo(ScreenWidth/3);
    }];
    UIButton *tipGoldBtn = [UIButton buttonWithImage:Image_Named(@"wallet_goldTip") selectedImage:Image_Named(@"wallet_goldTip")];
    tipGoldBtn.tag = 101;
    [tipGoldBtn addTarget:self action:@selector(tipBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:tipGoldBtn];
    [tipGoldBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(constGoldLab);
        make.left.equalTo(constGoldLab.mas_right).offset(-(ScreenWidth/12));
        make.height.width.equalTo(25);
    }];
    
    //self.goldLab   self.moneyLab
    UILabel *goldNumLab = [UILabel labelWithTitle:@"0" font:28 textColor:KCOLOR(@"#FFA500") textAlignment:1];
    goldNumLab.font = Font_Bold(28);
    [self addSubview:goldNumLab];
    self.goldLab = goldNumLab;
    [self.goldLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(constGoldLab);
        make.bottom.equalTo(constGoldLab.mas_top).offset(self.sizeW(-5));
    }];
    
    UILabel *moneyNumLab = [UILabel labelWithTitle:@"0" font:28 textColor:KCOLOR(@"#FFA500") textAlignment:1];
    moneyNumLab.font = Font_Bold(28);
    [self addSubview:moneyNumLab];
    self.moneyLab = moneyNumLab;
    [self.moneyLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(constMoneyLab).offset(12);
        make.bottom.equalTo(constMoneyLab.mas_top).offset(self.sizeW(-5));
    }];
    
    UIImageView *goldLogo = [[UIImageView alloc]initWithImage:Image_Named(@"walletGoldLogo")];
    [self addSubview:goldLogo];
    [goldLogo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.goldLab.mas_left).offset(-8);
        make.centerY.equalTo(self.goldLab);
    }];
    
    UIImageView *moneyLogo = [[UIImageView alloc]initWithImage:Image_Named(@"walletMoneyLogo")];
    [self addSubview:moneyLogo];
    [moneyLogo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.moneyLab.mas_left).offset(-8);
        make.centerY.equalTo(self.moneyLab);
    }];
    
    UIView *lineCardMid = [[UIView alloc]init];
    lineCardMid.backgroundColor = KCOLOR(@"#FFD700");
    [self addSubview:lineCardMid];
    [lineCardMid mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.goldLab);
        make.centerX.equalTo(self);
        make.height.equalTo(self.sizeW(26));
        make.width.equalTo(1.2f);
    }];
    
    //-------->>>BarButton_Line
    UIView *line = [[UIView alloc]init];
    line.backgroundColor = KCOLOR(@"#FFD700");
    [self addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self);
        make.height.equalTo(0.9f);
    }];
    UIView *lineMid = [[UIView alloc]init];
    lineMid.backgroundColor = KCOLOR(@"#FFD700");
    [self addSubview:lineMid];
    [lineMid mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(line.mas_bottom).offset(-10);
        make.centerX.equalTo(self);
        make.height.equalTo(barHeight-20);
        make.width.equalTo(1.2f);
    }];
    //BarButton
    UIButton *redBarBtn = [UIButton buttonWithTitle:@"红包明细" titleColor:LightGray_Color bgColor:nil highlightedColor:LightGray_Color];
    [redBarBtn setTitleColor:KCOLOR(@"#FFD700") forState:UIControlStateSelected];
    [redBarBtn.titleLabel setFont:Font_Size(18)];
    redBarBtn.tag = 1000;
    redBarBtn.selected = YES;
    [redBarBtn addTarget:self action:@selector(barBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:redBarBtn];
    self.redBarBtn = redBarBtn;
    [self.redBarBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(barHeight);
        make.width.equalTo(ScreenWidth/2 - 1);
        make.centerY.equalTo(lineMid);
        make.right.equalTo(lineMid.mas_left);
    }];
    UIButton *withdrawBarBtn = [UIButton buttonWithTitle:@"提现记录" titleColor:LightGray_Color bgColor:nil highlightedColor:LightGray_Color];
    [withdrawBarBtn setTitleColor:KCOLOR(@"#FFD700") forState:UIControlStateSelected];
    [withdrawBarBtn.titleLabel setFont:Font_Size(18)];
    withdrawBarBtn.tag = 1001;
    withdrawBarBtn.selected = NO;
    [withdrawBarBtn addTarget:self action:@selector(barBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:withdrawBarBtn];
    self.withdrawBarBtn = withdrawBarBtn;
    [self.withdrawBarBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(barHeight);
        make.width.equalTo(ScreenWidth/2 - 1);
        make.centerY.equalTo(lineMid);
        make.left.equalTo(lineMid.mas_right);
    }];
}

- (void)withdrawAction {
    if(self.withdrawBlock){
        self.withdrawBlock();
    }
}

- (void)getGoldAction {
    if(self.getGoldBlock){
        self.getGoldBlock();
    }
}

- (void)barBtnAction:(UIButton*)sender {
    if (sender.selected) {return;}
    sender.selected = YES;
    if (sender.tag == 1000) { //红包
        self.withdrawBarBtn.selected = NO;
    }else {  //提现
        self.redBarBtn.selected = NO;
    }
    
    if (self.barBtnClickBlock) {
        self.barBtnClickBlock(sender.tag == 1000);
    }
}

- (void)tipBtnAction:(UIButton *)sender {
    if (self.barBtnClickBlock) {
        self.barBtnClickBlock(sender.tag == 100);
    }
}

@end
