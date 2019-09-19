//
//  NetErrorOrNoDataView.m
//  CatEntertainment
//
//  Created by 闵玉辉 on 2017/11/17.
//  Copyright © 2017年 闵玉辉. All rights reserved.
//

#import "NetErrorOrNoDataView.h"
#import "HomeViewController.h"
@interface NetErrorOrNoDataView()
@property (nonatomic,weak) UIImageView * centerImg;
@property (nonatomic,weak) UILabel * titleLable;
@property (nonatomic,weak) UILabel * sublLable;
@property (nonatomic,weak) UIButton * reloadBtn;
@property (nonatomic,weak) UIViewController * containerView;
@end
@implementation NetErrorOrNoDataView
-(instancetype)initWithVC:(UIViewController *)VC
{
    if(self = [super init])
    {
        self.containerView = VC;
        [VC.view addSubview:self];
         BOOL isHome = [VC isKindOfClass:[HomeViewController class]];
        [self mas_makeConstraints:^(MASConstraintMaker *make) {
            if(!isHome){
            make.edges.equalTo(VC.view);
            }else
            {
                make.edges.equalTo(VC.view).offset(UIEdgeInsetsMake([self contentOffset], 0, 0, 0));
            }
        }];
        self.backgroundColor = KCOLOR(@"#f8f8f8");
        [self createUI];
    }
    return self;
}
-(void)createUI{
    
    UIImageView * imageV = [[UIImageView alloc]initWithImage:Image_Named(@"netError")];
    [self addSubview:imageV];
    self.centerImg = imageV;
    
    UILabel * titleLable = [[UILabel alloc]init];
    titleLable.font = KFONT(15);
    titleLable.textColor = KCOLOR(@"#333333");
    [self addSubview:titleLable];
    self.titleLable = titleLable;
    
    UILabel * subLable = [[UILabel alloc]init];
    subLable.font = KFONT(12);
    subLable.textColor = KCOLOR(@"#999999");
    subLable.text = @"请检查网络重新加载呗";
    [self addSubview:subLable];
    self.sublLable = subLable;
    
    UIButton * reloadBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [reloadBtn setImage:Image_Named(@"reload") forState:UIControlStateNormal];
    [reloadBtn addTarget:self action:@selector(reloadBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:reloadBtn];
    self.reloadBtn = reloadBtn;
}
-(void)reloadBtnClick
{
    if(self.reloadBlock)
    {
        self.reloadBlock(self);
    }
}
-(void)setStyle:(CEDefaultType)style
{
    _style = style;
    self.hidden = style == CEHiddenType?YES:NO;
    if(style!=CEHiddenType)
    {
        [self.containerView.view bringSubviewToFront:self];
    }
    [self makeMasWithStyle];
}
-(void)makeMasWithStyle
{
    switch (_style) {
        case CENetErrorType:
            {
                self.sublLable.hidden = NO;
                self.reloadBtn.hidden = NO;
                self.centerImg.image = Image_Named(@"netError");
                self.titleLable.text = @"网络请求竟然失败了";
                [self.titleLable mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.center.equalTo(self);
                }];
                
                [self.centerImg mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.centerX.equalTo(self);
                    make.bottom.equalTo(self.titleLable.mas_top).offset(-self.sizeH(25.f));
                }];
                
                [self.sublLable mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.centerX.equalTo(self);
                    make.top.equalTo(self.titleLable.mas_bottom).offset(self.sizeH(10.f));
                }];
                
                [self.reloadBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.centerX.equalTo(self);
                    make.top.equalTo(self.sublLable.mas_bottom).offset(self.sizeH(20.f));
                }];
            }
            break;
          case CENoDataType:
        {
            self.sublLable.hidden = YES;
            self.reloadBtn.hidden = YES;
            self.centerImg.image = Image_Named(@"homeEmptyLogo");
            self.titleLable.text = @"暂无更多数据了";
            [self.centerImg mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(self);
                make.bottom.equalTo(self.mas_centerY);
            }];
            
            [self.titleLable mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(self);
                make.top.equalTo(self.centerImg.mas_bottom).offset(self.sizeH(25.f));
            }];
            
        }
            break;
        default:
            break;
    }
    
}
@end
