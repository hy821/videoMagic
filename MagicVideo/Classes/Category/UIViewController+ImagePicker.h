//
//  UIViewController+ImagePicker.h
//  SmallStuff
//
//  Created by 闵玉辉 on 2017/8/4.
//  Copyright © 2017年 yuhuimin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HXPhotoModel.h"
typedef void(^PhotoBlock)(UIImage *photo);
typedef void(^PickBlock)(NSArray * imageArr,NSArray * assistArr);
typedef void (^VideoBlock)(NSString * videoPath,UIImage * image);
@interface UIViewController (ImagePicker)
/**
 *  TZImagePicker
 *
 *  @param videoBlock 视频回调
 *  @param isCamera 需要选择摄像
 */
-(void)pickVideo:(VideoBlock)videoBlock andNeedSelect:(BOOL)isCamera;
/**
 *  TZImagePicker
 *
 *  @param imageBlock 照片回调
 *  @param assistArr 需要传入的assist对象
 */
-(void)pickImageNum:(NSInteger)index andFinish:(PickBlock)imageBlock withAssistArr:(NSMutableArray *)assistArr;
/**
 *  系统照片选择->图库/相机
 *
 *  @param edit  照片是否需要裁剪,默认NO
 *  @param block 照片回调
 */
-(void)showCanEdit:(BOOL)edit photo:(PhotoBlock)block;
/**
 *  系统照片选择->图库/相机
 *  @param edit  照片是否需要裁剪,默认NO
 *  @param block 照片回调
 *  @param isCamera 是否需要拍照
 */
-(void)showCanEdit:(BOOL)edit photo:(PhotoBlock)block isTakeCamera:(BOOL)isCamera;
/**
 *  自定义照片选择->图库/相机
 *
 *  @param edit  照片是否需要裁剪,默认NO
 *  @param block 照片回调
 *  @param isCamera 是否需要拍照
 */
-(void)showCustomCanEdit:(BOOL)edit photo:(PhotoBlock)block isTakeCamera:(BOOL)isCamera;

-(void)pickImageNum:(NSInteger)index andFinish:(PickBlock)imageBlock withAssistArr:(NSMutableArray *)assistArr allowCrop:(BOOL)isNeed;
-(void)authorForCameraOrPhoto:(BOOL)isCamera;
@end
