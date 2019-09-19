//
//  SSPhotoCell.m
//  SmallStuff
//
//  Created by 闵玉辉 on 17/4/6.
//  Copyright © 2017年 yuhuimin. All rights reserved.
//

#import "SSPhotoCell.h"
#import "TZImageManager.h"
#import "UIView+Layout.h"
#import "TZImagePickerController.h"
@interface SSPhotoCell()
@property (nonatomic,weak) UIImageView * imgV;
@property (strong, nonatomic) UIView *bottomView;
@property (strong, nonatomic) UILabel *timeLength;
@property (nonatomic, strong) UIImageView *viewImgView;
@end
@implementation SSPhotoCell
-(instancetype)initWithFrame:(CGRect)frame
{
  if(self = [super initWithFrame:frame])
  {
      self.contentView.backgroundColor = [UIColor whiteColor];
      UIImageView * imageV = [[UIImageView alloc]init];
      imageV.contentMode = UIViewContentModeScaleAspectFill;
      imageV.clipsToBounds = YES;
      [self.contentView addSubview:imageV];
      self.imgV = imageV;
      [self.imgV mas_remakeConstraints:^(MASConstraintMaker *make) {
          make.edges.equalTo(self.contentView);
      }];
      [self.imgV addSubview:self.bottomView];
      
      [self.bottomView mas_remakeConstraints:^(MASConstraintMaker *make) {
          make.left.right.bottom.equalTo(self.imgV);
          make.height.mas_equalTo(17.f);
      }];
  }
    return self;
}
-(void)setModel:(TZAssetModel *)model
{
    _model = model;
    if (iOS8Later) {
        self.representedAssetIdentifier = [[TZImageManager manager] getAssetIdentifier:model.asset];
    }
    PHImageRequestID imageRequestID = [[TZImageManager manager] getPhotoWithAsset:model.asset photoWidth:self.tz_width completion:^(UIImage *photo, NSDictionary *info, BOOL isDegraded) {
        // Set the cell's thumbnail image if it's still showing the same asset.
        if (!iOS8Later) {
            self.imgV.image = photo; return;
        }
        if ([self.representedAssetIdentifier isEqualToString:[[TZImageManager manager] getAssetIdentifier:model.asset]]) {
            self.imgV.image = photo;
        } else {
            // NSLog(@"this cell is showing other asset");
            [[PHImageManager defaultManager] cancelImageRequest:self.imageRequestID];
        }
        if (!isDegraded) {
            self.imageRequestID = 0;
        }
    }];
    if (imageRequestID && self.imageRequestID && imageRequestID != self.imageRequestID) {
        [[PHImageManager defaultManager] cancelImageRequest:self.imageRequestID];
        // NSLog(@"cancelImageRequest %d",self.imageRequestID);
    }
    self.bottomView.hidden = YES;
    self.imageRequestID = imageRequestID;
    self.type = TZAssetCellTypePhoto;
    if (model.type == TZAssetModelMediaTypeLivePhoto)
    {
    self.type = TZAssetCellTypeLivePhoto;
    self.bottomView.hidden = YES;
    }
    else if (model.type == TZAssetModelMediaTypeAudio)
    {self.type = TZAssetCellTypeAudio;
    self.bottomView.hidden = YES;
    }
    else if (model.type == TZAssetModelMediaTypeVideo) {
        self.type = TZAssetCellTypeVideo;
        self.timeLength.text = model.timeLength;
        self.bottomView.hidden = NO;
    }
}

#pragma Lazy
- (UIView *)bottomView {
    if (_bottomView == nil) {
        UIView *bottomView = [[UIView alloc] init];
        bottomView.backgroundColor = [UIColor blackColor];
        bottomView.alpha = 0.8;
        _bottomView = bottomView;
    }
    return _bottomView;
}

- (UIImageView *)viewImgView {
    if (_viewImgView == nil) {
        UIImageView *viewImgView = [[UIImageView alloc] init];
        viewImgView.frame = CGRectMake(8, 0, 17, 17);
        [viewImgView setImage:[UIImage imageNamedFromMyBundle:@"VideoSendIcon.png"]];
        [self.bottomView addSubview:viewImgView];
        _viewImgView = viewImgView;
    }
    return _viewImgView;
}

- (UILabel *)timeLength {
    if (_timeLength == nil) {
        UILabel *timeLength = [[UILabel alloc] init];
        timeLength.font = [UIFont boldSystemFontOfSize:11];
        timeLength.frame = CGRectMake(self.viewImgView.tz_right, 0, self.tz_width - self.viewImgView.tz_right - 5, 17);
        timeLength.textColor = [UIColor whiteColor];
        timeLength.textAlignment = NSTextAlignmentRight;
        [self.bottomView addSubview:timeLength];
        _timeLength = timeLength;
    }
    return _timeLength;
}

@end
