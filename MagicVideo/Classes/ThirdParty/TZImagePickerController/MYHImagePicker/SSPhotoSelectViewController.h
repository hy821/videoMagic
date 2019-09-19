//
//  SSPhotoSelectViewController.h
//  SmallStuff
//
//  Created by 闵玉辉 on 17/4/6.
//  Copyright © 2017年 yuhuimin. All rights reserved.
//

#import "KSBaseViewController.h"
#import "TZAssetModel.h"
@interface SSPhotoSelectViewController : KSBaseViewController
@property (nonatomic,assign) BOOL isSelectVideo;
@property (nonatomic,assign) BOOL isSelectImg;
@property (nonatomic, strong) TZAlbumModel *model;
@end
