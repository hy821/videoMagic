//
//  VideoMsgCell.m
//  MagicVideo
//
//  Created by young He on 2019/9/24.
//  Copyright © 2019年 youngHe. All rights reserved.
//

#import "VideoMsgCell.h"
#import "UILabel+Category.h"
#import "UIButton+Category.h"
#import "HorizenButton.h"
#import "UIControl+recurClick.h"

@interface VideoMsgCell ()

@property (nonatomic,weak) UIImageView *iconIV;
@property (nonatomic, strong) UILabel *upNameLab;
@property (nonatomic, strong) UILabel *upDescLab;
@property (nonatomic, strong) UILabel *videoNameLab;
@property (nonatomic, strong) UILabel *viewCountLab; //观看量
@property (nonatomic,weak) HorizenButton *shareBtn;
@property (nonatomic,weak) HorizenButton *collectBtn;
@property (nonatomic,weak) HorizenButton *commentBtn;


@end

@implementation VideoMsgCell

+(instancetype)cellForTableView:(UITableView *)tableView {
    static NSString * ID = @"VideoMsgCell";
    VideoMsgCell * cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if(cell == nil) {
        cell = [[VideoMsgCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }return cell;
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self createUI];
    }return self;
}

-(void)createUI {
    self.contentView.backgroundColor = White_Color;
    UIImageView *iconIV = [[UIImageView alloc]init];
    iconIV.image = img_placeHolderIcon;
    iconIV.contentMode = UIViewContentModeScaleAspectFill;
    iconIV.layer.masksToBounds = YES;
    [self.contentView addSubview:iconIV];
    self.iconIV = iconIV;
    [self.iconIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(self.sizeW(8));
        make.left.equalTo(self.contentView).offset(self.sizeW(10));
        make.width.height.equalTo(self.sizeW(43));
    }];
    UIImageView *coverIV = [[UIImageView alloc]init];
    coverIV.image = Image_Named(@"circleWhite");
    coverIV.contentMode = UIViewContentModeScaleAspectFill;
    coverIV.layer.masksToBounds = YES;
    [self.contentView addSubview:coverIV];
    [coverIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.iconIV);
    }];
    
    [self.contentView addSubview:self.upNameLab];
    [self.contentView addSubview:self.upDescLab];
    [self.contentView addSubview:self.videoNameLab];
    [self.contentView addSubview:self.viewCountLab];
    
    [self.upNameLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.iconIV.mas_centerY).offset(self.sizeH(0));
        make.left.equalTo(self.iconIV.mas_right).offset(self.sizeW(5));
        make.right.equalTo(self.contentView).offset(self.sizeW(-10));
    }];
    [self.upDescLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.iconIV.mas_centerY).offset(self.sizeH(2));
        make.left.right.equalTo(self.upNameLab);
    }];
    
    [self.videoNameLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.iconIV);
        make.right.equalTo(self.contentView).offset(self.sizeW(-10));
        make.top.equalTo(self.iconIV.mas_bottom).offset(self.sizeW(14));
    }];

    [self.viewCountLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.videoNameLab);
//        make.right.equalTo(self.upNameLab);
        make.top.equalTo(self.videoNameLab.mas_bottom).offset(self.sizeW(10));
    }];
    
    CGFloat widthOfBtn = (ScreenWidth-self.sizeW(10)*2-self.sizeW(8)*2)/3;
    HorizenButton *commentBtn = [[HorizenButton alloc]init];
    [commentBtn setTitle:@"评论" forState:UIControlStateNormal];
    [commentBtn setTitle:@"评论" forState:UIControlStateSelected];
    commentBtn.titleLabel.font = Font_Size(12);
    [commentBtn setTitleColor:DarkGray_Color forState:UIControlStateNormal];
    [commentBtn setTitleColor:DarkGray_Color forState:UIControlStateSelected];
    commentBtn.isTitleLeft = NO;
    commentBtn.margeWidth = 6.f;
    commentBtn.uxy_acceptEventInterval = 0.5f;
    commentBtn.tag = 1001;
    commentBtn.layer.masksToBounds = YES;
    commentBtn.layer.cornerRadius = self.sizeW(20);
    commentBtn.backgroundColor = KCOLOR(@"#f9f9f9");
    [commentBtn setImage:Image_Named(@"ic_commentGray") forState:UIControlStateNormal];
    [commentBtn addTarget:self action:@selector(toolBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:commentBtn];
    self.commentBtn = commentBtn;
    [self.commentBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(widthOfBtn);
        make.height.equalTo(self.sizeW(40));
        make.left.equalTo(self.contentView).offset(self.sizeW(10));
        make.top.equalTo(self.viewCountLab.mas_bottom).offset(self.sizeW(8));
    }];
    
    HorizenButton *collectBtn = [[HorizenButton alloc]init];
    [collectBtn setTitle:@"收藏" forState:UIControlStateNormal];
    [collectBtn setTitle:@"收藏" forState:UIControlStateSelected];
    collectBtn.titleLabel.font = Font_Size(12);
    [collectBtn setTitleColor:DarkGray_Color forState:UIControlStateNormal];
    [collectBtn setTitleColor:DarkGray_Color forState:UIControlStateSelected];
    collectBtn.isTitleLeft = NO;
    collectBtn.margeWidth = 6.f;
    collectBtn.uxy_acceptEventInterval = 0.5f;
    collectBtn.tag = 1002;
    collectBtn.layer.masksToBounds = YES;
    collectBtn.layer.cornerRadius = self.sizeW(20);
    collectBtn.backgroundColor = KCOLOR(@"#f9f9f9");
    [collectBtn setImage:Image_Named(@"videoDetail_collect") forState:UIControlStateNormal];
    [collectBtn addTarget:self action:@selector(toolBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:collectBtn];
    self.collectBtn = collectBtn;
    [self.collectBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(self.commentBtn);
        make.centerY.equalTo(self.commentBtn);
        make.left.equalTo(self.commentBtn.mas_right).offset(self.sizeW(8));
    }];
    
    HorizenButton *shareBtn = [[HorizenButton alloc]init];
    [shareBtn setTitle:@"分享" forState:UIControlStateNormal];
    [shareBtn setTitle:@"分享" forState:UIControlStateSelected];
    shareBtn.titleLabel.font = Font_Size(12);
    [shareBtn setTitleColor:DarkGray_Color forState:UIControlStateNormal];
    [shareBtn setTitleColor:DarkGray_Color forState:UIControlStateSelected];
    shareBtn.isTitleLeft = NO;
    shareBtn.margeWidth = 6.f;
    shareBtn.uxy_acceptEventInterval = 0.5f;
    shareBtn.tag = 1003;
    shareBtn.layer.masksToBounds = YES;
    shareBtn.layer.cornerRadius = self.sizeW(20);
    shareBtn.backgroundColor = KCOLOR(@"#f9f9f9");
    [shareBtn setImage:Image_Named(@"videoDetail_share") forState:UIControlStateNormal];
    [shareBtn addTarget:self action:@selector(toolBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:shareBtn];
    self.shareBtn = shareBtn;
    [self.shareBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(self.commentBtn);
        make.centerY.equalTo(self.commentBtn);
        make.left.equalTo(self.collectBtn.mas_right).offset(self.sizeW(8));
    }];
    
    UIView *line = [[UIView alloc]init];
    line.backgroundColor = [UIColor darkGrayColor];
    [self.contentView addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.contentView);
        make.height.equalTo(0.7f);
    }];
    
    _upNameLab.text = @"百变影院";
    _upDescLab.text = @"精彩大片视频曝光，敬请关注。";
    _videoNameLab.text = @"一部好莱坞顶级科幻动作电影 简直是一场视觉的饕餮盛宴 极度震撼";
    _viewCountLab.text = @"2万次观看";
}

- (void)toolBtnAction:(HorizenButton *)sender {
    switch (sender.tag) {
        case 1001:
        {
            
        }
            break;
        case 1002:
        {
            
        }
            break;
        case 1003:
        {
            
        }
            break;
        default:
            break;
    }
}

- (UILabel *)upNameLab {
    if (!_upNameLab) {
        _upNameLab = [[UILabel alloc]init];
        _upNameLab.textColor = Black_Color;
        _upNameLab.font = [UIFont systemFontOfSize:15];
    }return _upNameLab;
}

- (UILabel *)upDescLab {
    if (!_upDescLab) {
        _upDescLab = [[UILabel alloc]init];
        _upDescLab.textColor = Black_Color;
        _upDescLab.font = [UIFont systemFontOfSize:11];
    }return _upDescLab;
}

- (UILabel *)videoNameLab {
    if (!_videoNameLab) {
        _videoNameLab = [[UILabel alloc]init];
        _videoNameLab.numberOfLines = 0;
        _videoNameLab.textColor = Black_Color;
        _videoNameLab.font = Font_Size(18);
    }return _videoNameLab;
}

- (UILabel *)viewCountLab {
    if (!_viewCountLab) {
        _viewCountLab = [[UILabel alloc]init];
        _viewCountLab.textColor = DarkGray_Color;
        _viewCountLab.font = [UIFont systemFontOfSize:11];
    }return _viewCountLab;
}
@end
