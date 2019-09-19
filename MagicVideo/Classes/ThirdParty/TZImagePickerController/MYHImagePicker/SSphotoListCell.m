//
//  SSphotoListCell.m
//  SmallStuff
//
//  Created by 闵玉辉 on 17/4/16.
//  Copyright © 2017年 yuhuimin. All rights reserved.
//

#import "SSphotoListCell.h"
#import "TZAssetModel.h"
@interface SSphotoListCell()
@property (nonatomic,weak) UIImageView * imageV;
@property (nonatomic,weak) UILabel * nameLable;
@end
@implementation SSphotoListCell
+(instancetype)cellForTableView:(UITableView *)tableView
{
  static NSString * ID = @"cell";
    SSphotoListCell * cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if(cell == nil)
    {
        cell = [[SSphotoListCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    return cell;
}
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
  if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
  {
      UIImageView * img = [[UIImageView alloc]init];
      img.contentMode = UIViewContentModeScaleAspectFill;
      img.clipsToBounds = YES;
      [self.contentView addSubview:img];
      self.imageV = img;
      
      UILabel * nameLable = [[UILabel alloc]init];
      [self.contentView addSubview:nameLable];
      self.nameLable = nameLable;
      
      [self.imageV mas_makeConstraints:^(MASConstraintMaker *make) {
          make.centerY.equalTo(self.contentView);
          make.left.equalTo(self.contentView).offset(4.f);
          make.height.width.mas_equalTo(70.f);
      }];
      [self.nameLable mas_makeConstraints:^(MASConstraintMaker *make) {
          make.left.equalTo(self.imageV.mas_right).offset(10.f);
          make.centerY.equalTo(self.contentView);
          make.height.mas_equalTo(15.f);
      }];
  }
    return self;
}
-(void)setModel:(TZAlbumModel *)model
{
    _model = model;
    NSMutableAttributedString *nameString = [[NSMutableAttributedString alloc] initWithString:model.name attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16],NSForegroundColorAttributeName:[UIColor blackColor]}];
    NSAttributedString *countString = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"  (%zd)",model.count] attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16],NSForegroundColorAttributeName:[UIColor lightGrayColor]}];
    [nameString appendAttributedString:countString];
    self.nameLable.attributedText = nameString;
    [[TZImageManager manager] getPostImageWithAlbumModel:model completion:^(UIImage *postImage) {
        self.imageV.image = postImage;
    }];
}
@end
