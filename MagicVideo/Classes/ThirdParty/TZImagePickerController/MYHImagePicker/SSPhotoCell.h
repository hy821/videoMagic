//
//  SSPhotoCell.h
//  SmallStuff
//
//  Created by 闵玉辉 on 17/4/6.
//  Copyright © 2017年 yuhuimin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TZAssetModel.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <Photos/Photos.h>
@interface SSPhotoCell : UICollectionViewCell
@property (nonatomic,strong )TZAssetModel *model;
@property (nonatomic, assign) TZAssetCellType type;
@property (nonatomic, copy) NSString *representedAssetIdentifier;
@property (nonatomic, assign) PHImageRequestID imageRequestID;
@end
