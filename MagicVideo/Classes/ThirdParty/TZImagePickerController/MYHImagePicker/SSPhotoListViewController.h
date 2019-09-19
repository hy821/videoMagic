//
//  SSPhotoListViewController.h
//  SmallStuff
//
//  Created by 闵玉辉 on 17/4/16.
//  Copyright © 2017年 yuhuimin. All rights reserved.
//

#import "KSBaseViewController.h"
#import "KSBaseNavViewController.h"
@interface SSPhotoListViewController : KSBaseNavViewController
// photos数组里的UIImage对象，默认是828像素宽，你可以通过设置photoWidth属性的值来改变它
@property (nonatomic, copy) void (^didFinishPickingPhotosHandle)(UIImage * image);
@property (nonatomic,copy) void (^didVideoFilePath)(NSString* path,UIImage * videoImg);
-(instancetype)initWithAllowVideo:(BOOL)isAllowVideo allowImage:(BOOL)isAllowImage;
@property (nonatomic,assign) BOOL isSelectVideo;
@property (nonatomic,assign) BOOL isSelectImg;
/// Default is YES.if set NO, the original photo button will hide. user can't picking original photo.
/// 默认为YES，如果设置为NO,原图按钮将隐藏，用户不能选择发送原图
@property (nonatomic, assign) BOOL allowPickingOriginalPhoto;

/// Default is YES.if set NO, user can't picking video.
/// 默认为YES，如果设置为NO,用户将不能选择发送视频
@property (nonatomic, assign) BOOL allowPickingVideo;

/// Default is YES.if set NO, user can't picking image.
/// 默认为YES，如果设置为NO,用户将不能选择发送图片
@property(nonatomic, assign) BOOL allowPickingImage;
/// Sort photos ascending by modificationDate，Default is YES
/// 对照片排序，按修改时间升序，默认是YES。如果设置为NO,最新的照片会显示在最前面，内部的拍照按钮会排在第一个
@property (nonatomic, assign) BOOL sortAscendingByModificationDate;

@end
@interface MYHAlbumPickerController : UIViewController

@end
