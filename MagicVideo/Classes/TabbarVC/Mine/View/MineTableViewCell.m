//
//  MineTableViewCell.m
//  KSMovie
//
//  Created by young He on 2018/9/14.
//  Copyright © 2018年 youngHe. All rights reserved.
//

#import "MineTableViewCell.h"
#import "UILabel+Category.h"

@interface MineTableViewCell ()
@property (nonatomic,weak) UIImageView *arrowIV;
@property (nonatomic,weak) UIImageView *iconIV;
@property (nonatomic,weak) UILabel *nameLab;
@property (nonatomic,weak) UIView *line;
@property (nonatomic,weak) UIControl *coverControl;
@property (nonatomic,weak) UIView *redPoint;
@end

@implementation MineTableViewCell

- (void)setModel:(MineTVCellModel *)model {
    _model = model;
    self.iconIV.image = Image_Named(model.imgName);
    self.nameLab.text = model.title;
    self.line.hidden = ([model.title containsString:@"联系我们"] ||  [model.title containsString:@"我的钱包"]);
    self.redPoint.hidden = !model.isShowRedPoint;
}

+(instancetype)cellForTableView:(UITableView *)tableView {
    static NSString * ID = @"MineTableViewCell";
    MineTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if(cell == nil) {
        cell = [[MineTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }return cell;
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self createUI];
    }return self;
}

-(void)createUI {
    self.clipsToBounds = YES;
    UIImageView *iconIV = [[UIImageView alloc]init];
    iconIV.contentMode = UIViewContentModeScaleAspectFill;
    [self.contentView addSubview:iconIV];
    self.iconIV = iconIV;
    [self.iconIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.left.equalTo(self.contentView).offset(self.sizeW(12));
        make.width.height.equalTo(self.sizeH(20));
    }];
    
    UILabel *lab = [UILabel labelWithTitle:@"" font:15 textColor:KCOLOR(@"#4A4A4A") textAlignment:1];
    [self.contentView addSubview:lab];
    self.nameLab = lab;
    [self.nameLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.iconIV);
        make.left.equalTo(self.iconIV.mas_right).offset(5);
    }];
    
    UIView *redPoint = [[UIView alloc]init];
    redPoint.backgroundColor = Red_Color;
    redPoint.layer.cornerRadius = self.sizeH(4);
    [self.contentView addSubview:redPoint];
    self.redPoint = redPoint;
    [self.redPoint mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nameLab.mas_right).offset(5);
        make.top.equalTo(self.nameLab);
        make.height.width.equalTo(self.sizeH(8));
    }];
    
    UIImageView *iv = [[UIImageView alloc]init];
    iv.image = Image_Named(@"ic_user_next");
    [self addSubview:iv];
    self.arrowIV = iv;
    [self.arrowIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.right.equalTo(self).offset(-self.sizeH(14));
    }];
    
    UIView *line = [[UIView alloc]init];
    line.backgroundColor = KCOLOR(@"#EEEDED");
    [self.contentView addSubview:line];
    self.line = line;
    [self.line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.iconIV);
        make.right.equalTo(self.arrowIV);
        make.bottom.equalTo(self.contentView);
        make.height.equalTo(0.7f);
    }];
}

@end
