//
//  WatchPointCell.m
//  KSMovie
//
//  Created by young He on 2018/10/9.
//  Copyright © 2018年 youngHe. All rights reserved.
//

#import "WatchPointCell.h"
#import "UILabel+Category.h"

@interface WatchPointCell()
@property (nonatomic,weak) UIImageView *videoIV;
@property (nonatomic,weak) UILabel *titleLab;
@end

@implementation WatchPointCell

//- (void)setModel:(SubjectListModel *)model {
//    _model = model;
//    [self.videoIV sd_setImageWithURL:URL(model.imageInfo.url) placeholderImage:img_placeHolder options:SDWebImageRetryFailed];
//    self.titleLab.text = model.subjectName;
//}

+(instancetype)cellForTableView:(UITableView *)tableView {
    static NSString * ID = @"WatchPointCell";
    WatchPointCell * cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if(cell == nil) {
        cell = [[WatchPointCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }return cell;
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self createUI];
    }return self;
}

-(void)createUI {
    UIImageView *videoIV = [[UIImageView alloc]init];
    videoIV.contentMode = UIViewContentModeScaleAspectFill;
    videoIV.clipsToBounds = YES;
    videoIV.layer.cornerRadius = self.sizeW(8);
    videoIV.layer.masksToBounds = YES;
    [self.contentView addSubview:videoIV];
    self.videoIV = videoIV;
    
    //Tempppppppppppppppppppppppppppppp
    self.videoIV.image = Image_Named(@"img_user_bg");
    //Tempppppppppppppppppppppppppppppp
    
    [self.videoIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView).insets(UIEdgeInsetsMake(self.sizeW(5), self.sizeW(12), self.sizeW(5), self.sizeW(12)));
    }];
    
    UIView *grayView = [[UIView alloc]init];
    grayView.backgroundColor = Black_Color;
    grayView.alpha = 0.3f;
    grayView.layer.cornerRadius = self.sizeW(8);
    grayView.layer.masksToBounds = YES;
    [self.videoIV addSubview:grayView];
    [grayView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView).insets(UIEdgeInsetsMake(self.sizeW(5), self.sizeW(12), self.sizeW(5), self.sizeW(12)));
    }];
    
    UILabel *titleLab = [UILabel labelWithTitle:@"" font:24 textColor:White_Color textAlignment:1];
    titleLab.font = Font_Bold(25);
    titleLab.numberOfLines = 0;
    [self.videoIV addSubview:titleLab];
    self.titleLab = titleLab;
    [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.videoIV);
        make.edges.equalTo(self.contentView).insets(UIEdgeInsetsMake(self.sizeH(50), self.sizeH(35), self.sizeH(50), self.sizeH(35)));
    }];
    
    UIView *lineTop = [[UIView alloc]init];
    lineTop.backgroundColor = White_Color;
    [self.contentView addSubview:lineTop];
    [lineTop mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self.titleLab);
        make.height.equalTo(0.4f);
    }];
    
    UIView *lineL = [[UIView alloc]init];
    lineL.backgroundColor = White_Color;
    [self.contentView addSubview:lineL];
    [lineL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.top.equalTo(self.titleLab);
        make.width.equalTo(0.4f);
    }];
    
    UIView *lineR = [[UIView alloc]init];
    lineR.backgroundColor = White_Color;
    [self.contentView addSubview:lineR];
    [lineR mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.top.bottom.equalTo(self.titleLab);
        make.width.equalTo(0.4f);
    }];
    
    UIView *lineBottom = [[UIView alloc]init];
    lineBottom.backgroundColor = White_Color;
    [self.contentView addSubview:lineBottom];
    [lineBottom mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleLab).offset(self.sizeW(25));
        make.right.equalTo(self.titleLab).offset(self.sizeW(-25));
        make.top.equalTo(self.titleLab.mas_bottom);
        make.height.equalTo(0.4f);
    }];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

@end
