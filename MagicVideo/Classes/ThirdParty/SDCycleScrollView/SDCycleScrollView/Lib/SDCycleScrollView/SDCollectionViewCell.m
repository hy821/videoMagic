//
//  SDCollectionViewCell.m
//  SDCycleScrollView
//
//  Created by aier on 15-3-22.
//  Copyright (c) 2015年 GSD. All rights reserved.
//


/**
 
 *******************************************************
 *                                                      *
 * 感谢您的支持， 如果下载的代码在使用过程中出现BUG或者其他问题    *
 * 您可以发邮件到gsdios@126.com 或者 到                       *
 * https://github.com/gsdios?tab=repositories 提交问题     *
 *                                                      *
 *******************************************************
 
 */


#import "SDCollectionViewCell.h"
#import "UIView+SDExtension.h"
//#import "GDTNativeExpressAd.h"
//#import "GDTNativeExpressAdView.h"

@interface SDCollectionViewCell ()
//<GDTNativeExpressAdDelegete>

//@property (nonatomic, strong) GDTNativeExpressAdView *expressView;
//@property (nonatomic, strong) GDTNativeExpressAd *nativeExpressAd;

@end

@implementation SDCollectionViewCell
{
    __weak UILabel *_titleLabel;
    __weak UIImageView *_gradientIV;
}

//Add---
//- (void)setModel:(RecycleModel *)model {
//    _model = model;
//    if (model.ad && model.ad.sspType && model.ad.sspId) {
//        AdvertisementModel *ad = model.ad;
//        switch (ad.adType) {
//                case ADTypeKS:
//            {
//                [self.imageView sd_setImageWithURL:URL(ad.url) placeholderImage:img_placeHolder];
//                self.title = ad.title;
//                [USER_MANAGER callBackAdvWithUrls:ad.showCallBackUrlList];
//            }
//                break;
//                case ADTypeGDT:
//            {
//                [[BuryingPointManager shareManager] buryingPointWithEventID:BP_HomeCycleAdvRequest andParameters:@{AD_NAME : @"GDT"}];
//
//                [USER_MANAGER callBackAdvWithUrls:ad.reqCallBackList];
//                self.nativeExpressAd = [[GDTNativeExpressAd alloc] initWithAppId:kGDTMobSDKAppId
//                                                                     placementId:ad.positionCode
//                                                                          adSize:CGSizeMake(ScreenWidth, (ScreenWidth*57/108))];
//                self.nativeExpressAd.delegate = self;
//                [self.nativeExpressAd loadAd:1];
//            }
//                break;
//            default:
//                break;
//        }
//    }else {
//        if (self.expressView) {
//            UIView *subView = (UIView *)[self.contentView viewWithTag:1000];
//            if ([subView superview] && [subView isMemberOfClass:[GDTNativeExpressAdView class]]) {
//                [subView removeFromSuperview];
//            }
//        }
//    }
//}
//
//#pragma mark - GDTNativeExpressAdDelegete
///**
// * 拉取广告成功的回调
// */
//- (void)nativeExpressAdSuccessToLoad:(GDTNativeExpressAd *)nativeExpressAd views:(NSArray<__kindof GDTNativeExpressAdView *> *)views {
//    if (views.count>0) {
//        self.expressView = views.firstObject;
//        self.expressView.controller = SelectVC;
//        [self.expressView render];
//    }
//}
//
///**
// * 拉取广告失败的回调
// */
//- (void)nativeExpressAdRenderFail:(GDTNativeExpressAdView *)nativeExpressAdView
//{
//    SSLog(@"Express Ad Render Fail");
//}
//
///**
// * 拉取原生模板广告失败
// */
//- (void)nativeExpressAdFailToLoad:(GDTNativeExpressAd *)nativeExpressAd error:(NSError *)error
//{
//    SSLog(@"Express Ad Load Fail : %@",error);
//}
//
//- (void)nativeExpressAdViewRenderSuccess:(GDTNativeExpressAdView *)nativeExpressAdView
//{
//    [USER_MANAGER callBackAdvWithUrls:self.model.ad.fillCallBackList];
//
//    UIView *subView = (UIView *)[self.contentView viewWithTag:1000];
//    if ([subView superview]) {
//        [subView removeFromSuperview];
//    }
//    self.expressView.tag = 1000;
//    [self.contentView addSubview:self.expressView];
//    [self.contentView bringSubviewToFront:self.expressView];
//}
//
//- (void)nativeExpressAdViewExposure:(GDTNativeExpressAdView *)nativeExpressAdView
//{
//    [[BuryingPointManager shareManager] buryingPointWithEventID:BP_HomeCycleAdvShow andParameters:@{AD_NAME : @"GDT"}];
//    [USER_MANAGER callBackAdvWithUrls:self.model.ad.showCallBackUrlList];
//}
//
//- (void)nativeExpressAdViewClicked:(GDTNativeExpressAdView *)nativeExpressAdView
//{
//    [[BuryingPointManager shareManager] buryingPointWithEventID:BP_HomeCycleAdvClick andParameters:@{AD_NAME : @"GDT"}];
//    [USER_MANAGER callBackAdvWithUrls:self.model.ad.clickCallBackUrlList];
//
//    [USER_MANAGER missControlForAdv];
//}
//
//- (void)nativeExpressAdViewClosed:(GDTNativeExpressAdView *)nativeExpressAdView
//{
//}

//----------------------------//----------------------------//


- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupImageView];
        [self setupTitleLabel];
    }return self;
}

- (void)setTitleLabelBackgroundColor:(UIColor *)titleLabelBackgroundColor
{
    _titleLabelBackgroundColor = titleLabelBackgroundColor;
    _titleLabel.backgroundColor = titleLabelBackgroundColor;
}

- (void)setTitleLabelTextColor:(UIColor *)titleLabelTextColor
{
    _titleLabelTextColor = titleLabelTextColor;
    _titleLabel.textColor = titleLabelTextColor;
}

- (void)setTitleLabelTextFont:(UIFont *)titleLabelTextFont
{
    _titleLabelTextFont = titleLabelTextFont;
    _titleLabel.font = titleLabelTextFont;
}

- (void)setupImageView
{
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    imageView.clipsToBounds = YES;
    _imageView = imageView;
    [self.contentView addSubview:imageView];
}

- (void)setupTitleLabel
{
    //Add---
    UIImageView *gradientIV = [[UIImageView alloc]init];
    _gradientIV = gradientIV;
    [self.contentView addSubview:gradientIV];
    
    WS()
    [Tool gradientColorWithRed:0 green:0 blue:0 startAlpha:1 endAlpha:0 direction:(DirectionStyleToUn) frame:CGRectMake(0, 0, 100, weakSelf.sizeH(40)) view:gradientIV];
    
    
    UILabel *titleLabel = [[UILabel alloc] init];
    _titleLabel = titleLabel;
    _titleLabel.hidden = YES;
    [self.contentView addSubview:titleLabel];
}

- (void)setTitle:(NSString *)title
{
    _title = [title copy];
    _titleLabel.text = [NSString stringWithFormat:@"   %@", title];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    _imageView.frame = self.bounds;
    CGFloat titleLabelW = self.sd_width;
    CGFloat titleLabelH = _titleLabelHeight;
    CGFloat titleLabelX = 0;
    CGFloat titleLabelY = self.sd_height - titleLabelH;
    _titleLabel.frame = CGRectMake(titleLabelX, titleLabelY, titleLabelW, titleLabelH);
    _titleLabel.hidden = !_titleLabel.text;
    _gradientIV.frame = _titleLabel.frame;
}

@end
