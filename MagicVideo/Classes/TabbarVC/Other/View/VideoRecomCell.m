//
//  VideoRecomCell.m
//  MagicVideo
//
//  Created by young He on 2019/9/24.
//  Copyright © 2019年 youngHe. All rights reserved.
//

#import "VideoRecomCell.h"

@interface VideoRecomCell()

@property (nonatomic,strong) UIImageView *coverImageView;
@property (nonatomic, strong) UILabel *videoNameLab;
@property (nonatomic, strong) UILabel *upNameLab;
@property (nonatomic, strong) UILabel *viewCountLab; //观看量

@end

@implementation VideoRecomCell

- (void)setIndexPath:(NSIndexPath *)indexPath {
    _indexPath = indexPath;
    self.videoNameLab.text = String_Integer(indexPath.row+1);
}

+(instancetype)cellForTableView:(UITableView *)tableView {
    static NSString * ID = @"VideoRecomCell";
    VideoRecomCell * cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if(cell == nil) {
        cell = [[VideoRecomCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
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
    [self.contentView addSubview:self.coverImageView];
    [self.contentView addSubview:self.upNameLab];
    [self.contentView addSubview:self.videoNameLab];
    [self.contentView addSubview:self.viewCountLab];

    [self.coverImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(self.sizeW(5));
        make.bottom.equalTo(self.contentView).offset(self.sizeW(-5));
        make.left.equalTo(self.contentView).offset(self.sizeW(12));
        make.width.equalTo(ScreenWidth*3/7);
    }];
    
    [self.upNameLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.coverImageView);
        make.left.equalTo(self.coverImageView.mas_right).offset(self.sizeW(8));
    }];
    
    [self.viewCountLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.upNameLab.mas_right).offset(self.sizeW(5));
        make.centerY.equalTo(self.upNameLab);
        make.right.equalTo(self.contentView).offset(self.sizeW(-8));
    }];
    
    [self.videoNameLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.coverImageView).offset(2);
        make.left.equalTo(self.coverImageView.mas_right).offset(self.sizeW(8));
        make.right.equalTo(self.contentView).offset(self.sizeW(-10));
        make.bottom.lessThanOrEqualTo(self.upNameLab.mas_top);
    }];
    
    [self.viewCountLab setContentCompressionResistancePriority:(UILayoutPriorityRequired) forAxis:(UILayoutConstraintAxisHorizontal)];
    [self.viewCountLab setContentHuggingPriority:(UILayoutPriorityRequired) forAxis:(UILayoutConstraintAxisHorizontal)];
    
    _upNameLab.text = @"百变娱乐影院";
    _videoNameLab.text = @"一部好莱坞顶级科幻动作电影 简直是一场视觉的饕一部好莱坞顶级科幻动作电影 极度震撼";
    _viewCountLab.text = @"20万次观看";
    _coverImageView.image = Image_Named(@"img_user_bg");
}

- (UIImageView *)coverImageView {
    if (!_coverImageView) {
        _coverImageView = [[UIImageView alloc] init];
        _coverImageView.tag = 100;
        _coverImageView.contentMode = UIViewContentModeScaleAspectFill;
        _coverImageView.layer.masksToBounds = YES;
        _coverImageView.layer.cornerRadius = self.sizeW(8);
    }return _coverImageView;
}

- (UILabel *)upNameLab {
    if (!_upNameLab) {
        _upNameLab = [[UILabel alloc]init];
        _upNameLab.textColor = LightGray_Color;
        _upNameLab.font = Font_Size(12);
    }return _upNameLab;
}

- (UILabel *)viewCountLab {
    if (!_viewCountLab) {
        _viewCountLab = [[UILabel alloc]init];
        _viewCountLab.textColor = LightGray_Color;
        _viewCountLab.font = Font_Size(12);
    }return _viewCountLab;
}

- (UILabel *)videoNameLab {
    if (!_videoNameLab) {
        _videoNameLab = [[UILabel alloc]init];
        _videoNameLab.numberOfLines = 0;
        _videoNameLab.textColor = Black_Color;
        _videoNameLab.font = Font_Size(16);
    }return _videoNameLab;
}

@end
