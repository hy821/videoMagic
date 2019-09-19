//
//  ShortVideoListCell.m
//  KSMovie
//
//  Created by young He on 2019/2/11.
//  Copyright © 2019年 youngHe. All rights reserved.
//

#import "ShortVideoListCell.h"
#import "UIImageView+ZFCache.h"
#import "UILabel+Category.h"
#import "HorizenButton.h"
#import "UIControl+recurClick.h"
//#import "GDTNativeExpressAd.h"
//#import "GDTNativeExpressAdView.h"

@interface ShortVideoListCell ()
//<GDTNativeExpressAdDelegete>
@property (nonatomic, strong) UIImageView *headImageView;
@property (nonatomic, strong) UILabel *nickNameLabel;
@property (nonatomic, strong) UIImageView *coverImageView;
@property (nonatomic, strong) UIView *fullMaskView;
@property (nonatomic, strong) UIButton *playBtn;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, weak) id<ShortVideoListCellDelegate> delegate;
@property (nonatomic, strong) NSIndexPath *indexPath;

@property (nonatomic,weak) HorizenButton *okBtn;
@property (nonatomic,weak) HorizenButton *badBtn;
@property (nonatomic,weak) HorizenButton *moreBtn;
@property (nonatomic,weak) HorizenButton *commentBtn;

//@property (nonatomic,strong) CountDownView *countDownView;
//@property (nonatomic, strong) GDTNativeExpressAdView *expressView;
//@property (nonatomic, strong) GDTNativeExpressAd *nativeExpressAd;
//@property (nonatomic,strong) AdvertisementModel *advModel;

@end

@implementation ShortVideoListCell

//- (void)refreshLikeOrSetOn:(ProgramResultListModel *)model {
//    [self.okBtn setTitle:model.interactResult.currentInfo.PRAISE forState:UIControlStateNormal];
//    [self.okBtn setTitle:model.interactResult.currentInfo.PRAISE forState:UIControlStateSelected];
//
//    [self.badBtn setTitle:model.interactResult.currentInfo.STEPON forState:UIControlStateNormal];
//    [self.badBtn setTitle:model.interactResult.currentInfo.STEPON forState:UIControlStateSelected];
//
//    if (model.interactResult.type.length>0) {
//        if ([model.interactResult.type isEqualToString:@"PRAISE"]) {
//            self.okBtn.selected = YES;
//            self.badBtn.selected = NO;
//        }else {
//            self.okBtn.selected = NO;
//            self.badBtn.selected = YES;
//        }
//    }else {
//        self.okBtn.selected = NO;
//        self.badBtn.selected = NO;
//    }
//}

//- (void)setModel:(ProgramResultListModel *)model {
//    _model = model;
//    [self resetAdvUI];
//
//    [self.headImageView setImageWithURLString:model.authors.firstObject.displayUrl placeholder:nil];
//    self.nickNameLabel.text = model.authors.firstObject.name;
//
//    //Tmp 测试服暂时修改
//    if([USER_MANAGER isDevStatus]) {
//        NSString *sss = [model.poster.url stringByReplacingOccurrencesOfString:@"images.ks.quanyuer.com" withString:@"images.ks.51tv.com"];
//        [self.coverImageView setImageWithURLString:sss placeholder:nil];
//    }else {
//        [self.coverImageView setImageWithURLString:model.poster.url placeholder:nil];
//    }
//
////    self.titleLabel.text = model.name;
//    self.titleLabel.text = [NSString stringWithFormat:@"keyWord:%@ 个数:%ld个 %@",model.keyWord,(long)model.keyWordCount,model.name];
//
//    [self.okBtn setTitle:model.interactResult.currentInfo.PRAISE forState:UIControlStateNormal];
//    [self.okBtn setTitle:model.interactResult.currentInfo.PRAISE forState:UIControlStateSelected];
//
//    [self.badBtn setTitle:model.interactResult.currentInfo.STEPON forState:UIControlStateNormal];
//    [self.badBtn setTitle:model.interactResult.currentInfo.STEPON forState:UIControlStateSelected];
//
//    if (model.interactResult.type.length>0) {
//        if ([model.interactResult.type isEqualToString:@"PRAISE"]) {
//            self.okBtn.selected = YES;
//            self.badBtn.selected = NO;
//        }else {
//            self.okBtn.selected = NO;
//            self.badBtn.selected = YES;
//        }
//    }else {
//        self.okBtn.selected = NO;
//        self.badBtn.selected = NO;
//    }
//
//    [self.headImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.contentView).offset(self.sizeH(10));
//        make.width.height.equalTo(self.sizeH(38));
//        make.left.equalTo(self.contentView).offset(self.sizeW(12));
//    }];
//    [self.nickNameLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
//        make.centerY.equalTo(self.headImageView);
//        make.left.equalTo(self.headImageView.mas_right).offset(self.sizeW(8));
//    }];
//    [self.coverImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.headImageView.mas_bottom).offset(self.sizeH(10));
//        make.left.right.equalTo(self.contentView);
//        make.height.equalTo(model.shortVideoHeight);
//    }];
//    [self.playBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
//        make.center.equalTo(self.coverImageView);
//    }];
//
//    CGFloat titleHeight = [Helper heightOfString:model.name font:Font_Size(17) width:(ScreenWidth-self.sizeW(20))];
//    titleHeight = titleHeight + self.sizeH(20);
//
//    [self.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.coverImageView.mas_bottom).offset(self.sizeH(0));
//        make.left.equalTo(self.contentView).offset(self.sizeW(10));
//        make.right.equalTo(self.contentView).offset(self.sizeW(-10));
//        make.height.equalTo(titleHeight);
//    }];
//}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self initUI];
    }return self;
}

- (void)initUI {
    self.contentView.backgroundColor = KCOLOR(@"#231F1F");
    [self.contentView addSubview:self.headImageView];
    [self.contentView addSubview:self.nickNameLabel];
    [self.contentView addSubview:self.coverImageView];
    [self.coverImageView addSubview:self.playBtn];
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.fullMaskView];

    CGFloat minVideoHeight = (ScreenWidth-self.sizeW(20))*585/1008;

    [self.headImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(self.sizeH(10));
        make.width.height.equalTo(self.sizeH(38));
        make.left.equalTo(self.contentView).offset(self.sizeW(12));
    }];
    [self.nickNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.headImageView);
        make.left.equalTo(self.headImageView.mas_right).offset(self.sizeW(8));
    }];
    [self.coverImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.headImageView.mas_bottom).offset(self.sizeH(10));
        make.left.right.equalTo(self.contentView);
        make.height.equalTo(minVideoHeight);
    }];
    [self.playBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.coverImageView);
    }];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.coverImageView.mas_bottom).offset(self.sizeH(10));
        make.left.equalTo(self.contentView).offset(self.sizeW(10));
        make.right.equalTo(self.contentView).offset(self.sizeW(-10));
    }];
    [self.fullMaskView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
    }];
    
//    [self.contentView addSubview:self.countDownView];
  
    HorizenButton *moreBtn = [[HorizenButton alloc]init];
    [moreBtn setTitle:@"" forState:UIControlStateNormal];
    moreBtn.titleLabel.font = Font_Size(12);
    [moreBtn setTitleColor:KCOLOR(@"#4A4A4A") forState:UIControlStateNormal];
    [moreBtn setTitleColor:KCOLOR(@"#4A4A4A") forState:UIControlStateSelected];
    moreBtn.isTitleLeft = NO;
    moreBtn.margeWidth = 2.f;
    moreBtn.uxy_acceptEventInterval = 0.3f;
    [moreBtn setImage:Image_Named(@"svRecomList_more") forState:UIControlStateNormal];
    [moreBtn setImage:Image_Named(@"svRecomList_more") forState:UIControlStateSelected];
    [moreBtn addTarget:self action:@selector(moreShareBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:moreBtn];
    self.moreBtn = moreBtn;
    [self.moreBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(ScreenWidth/4);
        make.right.equalTo(self.contentView).offset(self.sizeW(-10));
        make.top.equalTo(self.titleLabel.mas_bottom).offset(0);
        make.bottom.equalTo(self.contentView);
    }];
    
    //评论按钮先隐藏
    HorizenButton *commentBtn = [[HorizenButton alloc]init];
    [commentBtn setTitle:@"评论" forState:UIControlStateNormal];
    [commentBtn setTitle:@"评论" forState:UIControlStateSelected];
    commentBtn.titleLabel.font = Font_Size(12);
    [commentBtn setTitleColor:KCOLOR(@"#4A4A4A") forState:UIControlStateNormal];
    [commentBtn setTitleColor:KCOLOR(@"#4A4A4A") forState:UIControlStateSelected];
    commentBtn.isTitleLeft = NO;
    commentBtn.margeWidth = 2.f;
    commentBtn.userInteractionEnabled = NO;
    [commentBtn setImage:Image_Named(@"ic_commentGray") forState:UIControlStateNormal];
    [commentBtn setImage:Image_Named(@"ic_commentGray") forState:UIControlStateSelected];
    [self.contentView addSubview:commentBtn];
    self.commentBtn = commentBtn;
    [self.commentBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(self.moreBtn);
        make.height.equalTo(self.moreBtn);
        make.right.equalTo(self.moreBtn.mas_left).offset(0);
        make.centerY.equalTo(self.moreBtn);
    }];
    
    HorizenButton *badBtn = [[HorizenButton alloc]init];
    [badBtn setTitle:@"踩" forState:UIControlStateNormal];
    [badBtn setTitle:@"踩" forState:UIControlStateSelected];
    badBtn.titleLabel.font = Font_Size(12);
    [badBtn setTitleColor:KCOLOR(@"#4A4A4A") forState:UIControlStateNormal];
    [badBtn setTitleColor:KCOLOR(@"#4A4A4A") forState:UIControlStateSelected];
    badBtn.isTitleLeft = NO;
    badBtn.margeWidth = 2.f;
    badBtn.tag = 200;
    badBtn.uxy_acceptEventInterval = 0.5f;
    [badBtn setImage:Image_Named(@"ic_unlike") forState:UIControlStateNormal];
    [badBtn setImage:Image_Named(@"ic_unlike_choose") forState:UIControlStateSelected];
    [badBtn addTarget:self action:@selector(likeOrSetOnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:badBtn];
    self.badBtn = badBtn;
    [self.badBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(self.moreBtn);
        make.height.equalTo(self.moreBtn);
        make.right.equalTo(self.commentBtn.mas_left).offset(0);
        make.centerY.equalTo(self.moreBtn);
    }];
    
    HorizenButton *okBtn = [[HorizenButton alloc]init];
    [okBtn setTitle:@"赞" forState:UIControlStateNormal];
    [okBtn setTitle:@"赞" forState:UIControlStateSelected];
    okBtn.titleLabel.font = Font_Size(12);
    [okBtn setTitleColor:KCOLOR(@"#4A4A4A") forState:UIControlStateNormal];
    [okBtn setTitleColor:KCOLOR(@"#4A4A4A") forState:UIControlStateSelected];
    okBtn.isTitleLeft = NO;
    okBtn.margeWidth = 2.f;
    okBtn.tag = 100;
    okBtn.uxy_acceptEventInterval = 0.5f;
    [okBtn setImage:Image_Named(@"ic_like") forState:UIControlStateNormal];
    [okBtn setImage:Image_Named(@"ic_like_choose") forState:UIControlStateSelected];
    [okBtn addTarget:self action:@selector(likeOrSetOnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:okBtn];
    self.okBtn = okBtn;
    [self.okBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(self.moreBtn);
        make.height.equalTo(self.moreBtn);
        make.right.equalTo(self.badBtn.mas_left).offset(0);
        make.centerY.equalTo(self.moreBtn);
    }];
    
    UIView *line = [[UIView alloc]init];
    line.backgroundColor = [UIColor darkGrayColor];
    [self.contentView addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.contentView);
        make.height.equalTo(0.8f);
    }];
    
}

- (void)likeOrSetOnAction:(HorizenButton *)sender {
    
//    [[BuryingPointManager shareManager] buryingPointWithEventID:(sender.tag==100)?BP_SVListLike:BP_SVListUnLike andParameters:@{}];
//
//    NSString *clickType = (sender.tag==100) ? @"PRAISE" : @"STEPON";
//    NSDictionary *dic = @{@"assetType" : self.model.type,
//                          @"programId" : self.model.idForModel,
//                          @"type" : clickType
//                          };
//    [USER_MANAGER shortVideoInteractWithPar:dic success:^(id response) {
//
//        sender.selected = !sender.selected;
//
//        if (sender.tag == 100) { //赞Btn
//
//            if (sender.isSelected) {  //点赞完成 +1
//                NSInteger num = [_model.interactResult.currentInfo.PRAISE integerValue];
//                _model.interactResult.currentInfo.PRAISE = [NSString stringWithFormat:@"%d",num+1];
//                if ([_model.interactResult.type isEqualToString:@"STEPON"]) {
//                    NSInteger numStepOn = [_model.interactResult.currentInfo.STEPON integerValue];
//                    _model.interactResult.currentInfo.STEPON = [NSString stringWithFormat:@"%d",numStepOn-1];
//                }
//                _model.interactResult.type = @"PRAISE";
//            }else { //取消点赞完成 -1
//                NSInteger num = [_model.interactResult.currentInfo.PRAISE integerValue];
//                _model.interactResult.currentInfo.PRAISE = [NSString stringWithFormat:@"%d",num-1 < 0 ? 0 : num-1];
//                _model.interactResult.type = @"";
//            }
//        }else {  //踩Btn
//
//            if (sender.isSelected) {  //点踩完成 +1
//                NSInteger num = [_model.interactResult.currentInfo.STEPON integerValue];
//                _model.interactResult.currentInfo.STEPON = [NSString stringWithFormat:@"%d",num+1];
//                if ([_model.interactResult.type isEqualToString:@"PRAISE"]) {
//                    NSInteger numPRAISE = [_model.interactResult.currentInfo.PRAISE integerValue];
//                    _model.interactResult.currentInfo.PRAISE = [NSString stringWithFormat:@"%d",numPRAISE-1];
//                }
//                _model.interactResult.type = @"STEPON";
//            }else { //取消踩完成 -1
//                NSInteger num = [_model.interactResult.currentInfo.STEPON integerValue];
//                _model.interactResult.currentInfo.STEPON = [NSString stringWithFormat:@"%d",num-1 < 0 ? 0 : num-1];
//                _model.interactResult.type = @"";
//            }
//        }
//
//        //刷新UI  原本用 [self setModel:_model];  但是 播放5秒广告时这样更新会出问题
//        [self refreshLikeOrSetOn:_model];
//
//        //点过赞或踩之后通知外面更新数据
//        if (self.upDataModelBlock) {
//            self.upDataModelBlock(self.model);
//        }
//
//    } failure:^(NSString *errorMsg) {
//        SSMBToast(errorMsg, MainWindow);
//    }];
}

- (void)moreShareBtnAction {
//    if(self.showMoreShareViewBlock) {
//        self.showMoreShareViewBlock();
//    }
}

- (void)setDelegate:(id<ShortVideoListCellDelegate>)delegate withIndexPath:(NSIndexPath *)indexPath {
    self.delegate = delegate;
    self.indexPath = indexPath;
}

- (void)setNormalMode {
    self.fullMaskView.hidden = YES;
    self.titleLabel.textColor = [UIColor blackColor];
    self.nickNameLabel.textColor = [UIColor blackColor];
    self.contentView.backgroundColor = [UIColor whiteColor];
}

//- (void)showMaskView {
//    [self resetAdvUI];
//
//    [UIView animateWithDuration:0.3 animations:^{
//        self.fullMaskView.alpha = 1;
//    }];
//}
//
//- (void)hideMaskViewWithAdv:(BOOL)isShowAdv {
//    if (isShowAdv) {
//        [self showCountDownAdv];
//    }
//
//    [UIView animateWithDuration:0.3 animations:^{
//        self.fullMaskView.alpha = 0;
//    }];
//}

- (void)playBtnClick:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(zf_playTheVideoAtIndexPath:)]) {
        [self.delegate zf_playTheVideoAtIndexPath:self.indexPath];
    }
}

//------Adv------//
- (void)showCountDownAdv {
//    [self resetAdvUI];
//
//    NSDictionary *dic = [USER_MANAGER getAdvParamDicWithPositionID:kGDTPositionId_insertHomeCell slotWidth:ScreenWidth slotHeight:ScreenWidth*0.6];
//
//    [[SSRequest request]POST:Adv_SplashUrl parameters:dic.mutableCopy success:^(SSRequest *request, id response) {
//
//        if(response[@"data"]) {  //有广告.
//            AdvertisementModel *m = [AdvertisementModel mj_objectWithKeyValues:response[@"data"]];
//            [m refreshModel];
//            self.advModel = m;
//            switch (m.adType) {
//                case ADTypeGDT:
//                {
//                    [USER_MANAGER callBackAdvWithUrls:m.reqCallBackList];
//                    self.nativeExpressAd = [[GDTNativeExpressAd alloc] initWithAppId:kGDTMobSDKAppId
//                                                                         placementId:m.positionCode
//                                                                              adSize:CGSizeMake(ScreenWidth, ScreenWidth*0.6)];
//                    self.nativeExpressAd.delegate = self;
//                    [self.nativeExpressAd loadAd:1];
//                }
//                    break;
//                default:
//                {
//                    [USER_MANAGER showShortVideoDayOnceAdvSuccessWithShortVideoID:self.model.idForModel];
//                }
//                    break;
//            }
//        }else {
//            if(self.advFinishToPlayVideoBlock) {
//                self.advFinishToPlayVideoBlock(NO);
//            }
//        }
//    } failure:^(SSRequest *request, NSString *errorMsg) {
//        [USER_MANAGER showShortVideoDayOnceAdvSuccessWithShortVideoID:self.model.idForModel];
//    }];
}
//
////重置广告相关  移除广告  隐藏countDownView  显示coverImageView
//- (void)resetAdvUI {
//    self.coverImageView.hidden = NO;
//    [self.contentView bringSubviewToFront:self.fullMaskView];
//    if(self.countDownView) {
//        self.countDownView.hidden = YES;
//        [self.countDownView destroy];
//    }
//    if(self.expressView) {
//        [self.expressView removeFromSuperview];
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
//    if(self.advFinishToPlayVideoBlock) {
//        self.advFinishToPlayVideoBlock(YES);
//    }
//}
//
///**
// * 拉取原生模板广告失败
// */
//- (void)nativeExpressAdFailToLoad:(GDTNativeExpressAd *)nativeExpressAd error:(NSError *)error
//{
//    if(self.advFinishToPlayVideoBlock) {
//        self.advFinishToPlayVideoBlock(YES);
//    }
//}
//
//- (void)nativeExpressAdViewRenderSuccess:(GDTNativeExpressAdView *)nativeExpressAdView
//{
//    [USER_MANAGER callBackAdvWithUrls:self.advModel.fillCallBackList];
//
//    UIView *subView = (UIView *)[self.contentView viewWithTag:1000];
//    if ([subView superview]) {
//        [subView removeFromSuperview];
//    }
//    self.expressView.tag = 1000;
//    self.coverImageView.hidden = YES;
//    self.countDownView.hidden = NO;
//    [self.contentView addSubview:self.expressView];
//
//    CGFloat minVideoHeight = (ScreenWidth-self.sizeW(20))*585/1008;
//
//    [self.expressView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.width.equalTo(self.coverImageView);
//        make.center.equalTo(self.coverImageView);
//        make.height.equalTo(minVideoHeight);
//    }];
//    [self.countDownView mas_remakeConstraints:^(MASConstraintMaker *make) {
//        make.right.equalTo(self.contentView);
//        make.width.equalTo(self.sizeW(70));
//        make.height.equalTo(self.sizeH(30));
//        make.top.equalTo(self.expressView).offset(self.sizeH(30));
//    }];
//    [self.contentView bringSubviewToFront:self.expressView];
//    [self.contentView bringSubviewToFront:self.countDownView];
//    [self.countDownView startWithCount:5];
//}
//
//- (void)nativeExpressAdViewExposure:(GDTNativeExpressAdView *)nativeExpressAdView
//{
//    [USER_MANAGER callBackAdvWithUrls:self.advModel.showCallBackUrlList];
//}
//
//- (void)nativeExpressAdViewClicked:(GDTNativeExpressAdView *)nativeExpressAdView
//{
//    [USER_MANAGER callBackAdvWithUrls:self.advModel.clickCallBackUrlList];
//}
//
//- (void)nativeExpressAdViewClosed:(GDTNativeExpressAdView *)nativeExpressAdView
//{
//}
//
///**
// * 原生模板广告渲染失败
// */
//- (void)nativeExpressAdViewRenderFail:(GDTNativeExpressAdView *)nativeExpressAdView {
//    SSLog(@"");
//}


#pragma mark -------- getter
- (UIButton *)playBtn {
    if (!_playBtn) {
        _playBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_playBtn setImage:[UIImage imageNamed:@"new_allPlay_44x44_"] forState:UIControlStateNormal];
        [_playBtn addTarget:self action:@selector(playBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }return _playBtn;
}

- (UIView *)fullMaskView {
    if (!_fullMaskView) {
        _fullMaskView = [UIView new];
        _fullMaskView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.8];
        _fullMaskView.userInteractionEnabled = NO;
    }return _fullMaskView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [UILabel new];
        _titleLabel.textColor = [UIColor whiteColor];
        _titleLabel.numberOfLines = 0;
        _titleLabel.font = [UIFont systemFontOfSize:17];
    }return _titleLabel;
}

- (UILabel *)nickNameLabel {
    if (!_nickNameLabel) {
        _nickNameLabel = [UILabel new];
        _nickNameLabel.textColor = [UIColor whiteColor];
        _nickNameLabel.font = [UIFont systemFontOfSize:15];
    }return _nickNameLabel;
}

- (UIImageView *)headImageView {
    if (!_headImageView) {
        _headImageView = [[UIImageView alloc] init];
        _headImageView.userInteractionEnabled = YES;
        _headImageView.layer.masksToBounds = YES;
        _headImageView.layer.cornerRadius = self.sizeH(38/2);
    }return _headImageView;
}

- (UIImageView *)coverImageView {
    if (!_coverImageView) {
        _coverImageView = [[UIImageView alloc] init];
        _coverImageView.userInteractionEnabled = YES;
        _coverImageView.tag = 100;
        _coverImageView.contentMode = UIViewContentModeScaleAspectFill;
        _coverImageView.clipsToBounds = YES;
    }return _coverImageView;
}

//-(CountDownView *)countDownView {
//    if (!_countDownView) {
//        _countDownView = [[CountDownView alloc] initWithFrame:CGRectMake(ScreenWidth-self.sizeW(70), self.sizeH(90), self.sizeW(70), self.sizeH(30))];
//        _countDownView.hidden = YES;
//        WS()
//        _countDownView.skipClickBlock = ^{
//            weakSelf.coverImageView.hidden = NO;
//            weakSelf.countDownView.hidden = YES;
//            if (weakSelf.expressView) {
//                [weakSelf.expressView removeFromSuperview];
//            }
//            if (weakSelf.advFinishToPlayVideoBlock) {
//                weakSelf.advFinishToPlayVideoBlock(YES);
//            }
//        };
//    }return _countDownView;
//}

@end
