//
//  UIViewController+ImagePicker.m
//  SmallStuff
//
//  Created by 闵玉辉 on 2017/8/4.
//  Copyright © 2017年 yuhuimin. All rights reserved.
//

#import "UIViewController+ImagePicker.h"
#import "TZImagePickerController.h"
#import "SSPhotoListViewController.h"
#import "LCActionSheet.h"
#import "objc/runtime.h"
#import <AssetsLibrary/ALAssetsLibrary.h>
#import "SSPhotoListViewController.h"
#ifdef DEBUG
#define debugLog(...)    NSLog(__VA_ARGS__)
#else
#define debugLog(...)
#endif

static  BOOL canEdit = NO;
const  char * blockKey = "blockKey";
const char * videokey = "videoKey";
@interface UIViewController()<
UIActionSheetDelegate,
UINavigationControllerDelegate,
UIImagePickerControllerDelegate,
UIAlertViewDelegate>

@property (nonatomic,copy)PhotoBlock photoBlock;
@property (nonatomic,copy) VideoBlock videoBlock;
@end
@implementation UIViewController (ImagePicker)
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"

/**
 *  TZImagePicker
 *
 *  @param videoBlock 视频回调
 *  @param isNeed 需要选择摄像
 */
-(void)pickVideo:(VideoBlock)videoBlock andNeedSelect:(BOOL)isCamera
{
    //权限
    ALAuthorizationStatus author = [ALAssetsLibrary authorizationStatus];
    if (author == ALAuthorizationStatusRestricted || author ==ALAuthorizationStatusDenied) {
        NSString *photoType =@"相册";
        NSString * title = [NSString stringWithFormat:@"%@权限未开启",photoType];
        NSString * msg = [NSString stringWithFormat:@"请在系统设置中开启该应用%@服务\n(设置->隐私->%@->开启)",photoType,photoType];
        NSString * cancelTitle = @"知道了";
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title message:msg delegate:self cancelButtonTitle:cancelTitle otherButtonTitles:@"设置", nil];
        [alertView show];
        debugLog(@"%@权限未开启",photoType);
        return;
    }
    if(isCamera)
    {
       
    }else
    {
        self.videoBlock = videoBlock;
        SSPhotoListViewController * ssPhoto = [[SSPhotoListViewController alloc]initWithAllowVideo:YES allowImage:NO];
        // 3. 设置是否可以选择视频/图片/原图
        ssPhoto.allowPickingVideo = YES;
        ssPhoto.allowPickingImage = NO;
        ssPhoto.allowPickingOriginalPhoto = NO;
        // 4. 照片排列按修改时间升序
        ssPhoto.sortAscendingByModificationDate = YES;
        __block VideoBlock weakBlock = videoBlock;
        ssPhoto.didVideoFilePath = ^(NSString * videoPath,UIImage * image){
            
            if(weakBlock) {
                weakBlock(videoPath,image);
            }
        };
        [self presentViewController:ssPhoto animated:YES completion:nil];
        
    }
    
}
-(void)cameraDidNextClick:(HXPhotoModel *)model
{
       if(self.videoBlock)
   {
       self.videoBlock(model.videoURL.absoluteString, model.previewPhoto);
   }
}
-(void)authorForCameraOrPhoto:(BOOL)isCamera
{
    dispatch_async(dispatch_get_main_queue(), ^{
        NSString *photoType = isCamera?@"相机" : @"照片";
        NSString * title = [NSString stringWithFormat:@"%@权限未开启",photoType];
        NSString * msg = [NSString stringWithFormat:@"请在系统设置中开启该应用%@服务\n(设置->隐私->%@->开启)",photoType,photoType];
        NSString * cancelTitle = @"知道了";
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title message:msg delegate:self cancelButtonTitle:cancelTitle otherButtonTitles:@"设置", nil];
        [alertView show];
   });
}

-(void)pickImageNum:(NSInteger)index andFinish:(PickBlock)imageBlock withAssistArr:(NSMutableArray *)assistArr allowCrop:(BOOL)isNeed{
    //权限
    ALAuthorizationStatus author = [ALAssetsLibrary authorizationStatus];
    if (author == ALAuthorizationStatusRestricted || author ==ALAuthorizationStatusDenied) {
        NSString *photoType =@"照片";
        NSString * title = [NSString stringWithFormat:@"%@权限未开启",photoType];
        NSString * msg = [NSString stringWithFormat:@"请在系统设置中开启该应用%@服务\n(设置->隐私->%@->开启)",photoType,photoType];
        NSString * cancelTitle = @"知道了";
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title message:msg delegate:self cancelButtonTitle:cancelTitle otherButtonTitles:@"设置", nil];
        [alertView show];
        debugLog(@"%@权限未开启",photoType);
        return;
    }
    TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:index delegate:nil];
#pragma mark - 四类个性化设置，这些参数都可以不传，此时会走默认设置
    imagePickerVc.photoWidth = 1000;
    // 1.如果你需要将拍照按钮放在外面，不要传这个参数
    imagePickerVc.selectedAssets = assistArr; // optional, 可选的
    imagePickerVc.allowTakePicture = NO; // 在内部显示拍照按钮
    // 2. Set the appearance
    // 2. 在这里设置imagePickerVc的外观
    // imagePickerVc.navigationBar.barTintColor = [UIColor greenColor];
    imagePickerVc.oKButtonTitleColorDisabled = [UIColor lightGrayColor];
    //        imagePickerVc.oKButtonTitleColorNormal = [Utils colorConvertFromString:@"#00c0ff"];
    // 3. Set allow picking video & photo & originalPhoto or not
    // 3. 设置是否可以选择视频/图片/原图
    imagePickerVc.allowPickingVideo = NO;
    imagePickerVc.allowPickingImage = YES;
    imagePickerVc.allowPickingOriginalPhoto = NO;
    // 4. 照片排列按修改时间升序
    imagePickerVc.sortAscendingByModificationDate = YES;
    imagePickerVc.allowCrop = isNeed;
    if(isNeed) {
        imagePickerVc.allowCrop = YES;
        imagePickerVc.cropRect = CGRectMake(0, (ScreenHeight-ScreenWidth)/2.0, ScreenWidth, ScreenWidth);
    }
    imagePickerVc.naviTitleColor = KCOLOR(@"#333333");
    imagePickerVc.naviTitleFont = KFONT(17);
    imagePickerVc.barItemTextFont = KFONT(15);
    imagePickerVc.barItemTextColor = KCOLOR(@"#333333");
    
#pragma mark - 到这里为止
    
    // You can get the photos by block, the same as by delegate.
    // 你可以通过block或者代理，来得到用户选择的照片.
    __block PickBlock weakBlock = imageBlock;
    [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
        if(weakBlock) {
            weakBlock(photos,assets);
        }
    }];
    [self presentViewController:imagePickerVc animated:YES completion:nil];
}

-(void)pickImageNum:(NSInteger)index andFinish:(PickBlock)imageBlock withAssistArr:(NSMutableArray *)assistArr
{
    //权限
    ALAuthorizationStatus author = [ALAssetsLibrary authorizationStatus];
    if (author == ALAuthorizationStatusRestricted || author ==ALAuthorizationStatusDenied) {
        NSString *photoType =@"相册";
        NSString * title = [NSString stringWithFormat:@"%@权限未开启",photoType];
        NSString * msg = [NSString stringWithFormat:@"请在系统设置中开启该应用%@服务\n(设置->隐私->%@->开启)",photoType,photoType];
        NSString * cancelTitle = @"知道了";
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title message:msg delegate:self cancelButtonTitle:cancelTitle otherButtonTitles:@"设置", nil];
        [alertView show];
        debugLog(@"%@权限未开启",photoType);
        return;
    }
    TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:index delegate:nil];
#pragma mark - 四类个性化设置，这些参数都可以不传，此时会走默认设置
    imagePickerVc.photoWidth = 1000;
    // 1.如果你需要将拍照按钮放在外面，不要传这个参数
    imagePickerVc.selectedAssets = assistArr; // optional, 可选的
    imagePickerVc.allowTakePicture = NO; // 在内部显示拍照按钮
    // 2. Set the appearance
    // 2. 在这里设置imagePickerVc的外观
    // imagePickerVc.navigationBar.barTintColor = [UIColor greenColor];
    imagePickerVc.oKButtonTitleColorDisabled = [UIColor lightGrayColor];
    //        imagePickerVc.oKButtonTitleColorNormal = [Utils colorConvertFromString:@"#00c0ff"];
    // 3. Set allow picking video & photo & originalPhoto or not
    // 3. 设置是否可以选择视频/图片/原图
    imagePickerVc.allowPickingVideo = NO;
    imagePickerVc.allowPickingImage = YES;
    imagePickerVc.allowPickingOriginalPhoto = NO;
    // 4. 照片排列按修改时间升序
    imagePickerVc.sortAscendingByModificationDate = YES;
    
    imagePickerVc.naviTitleColor = KCOLOR(@"#333333");
    imagePickerVc.naviTitleFont = KFONT(17);
    imagePickerVc.barItemTextFont = KFONT(15);
    imagePickerVc.barItemTextColor = KCOLOR(@"#333333");
  
#pragma mark - 到这里为止
    
    // You can get the photos by block, the same as by delegate.
    // 你可以通过block或者代理，来得到用户选择的照片.
    __block PickBlock weakBlock = imageBlock;
    [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
        if(weakBlock)
        {
            weakBlock(photos,assets);
        }
    }];
    [self presentViewController:imagePickerVc animated:YES completion:nil];

}
#pragma mark--系统
-(void)setPhotoBlock:(PhotoBlock)photoBlock
{
    objc_setAssociatedObject(self, &blockKey, photoBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
}
-(void)setVideoBlock:(VideoBlock)videoBlock
{
    objc_setAssociatedObject(self, &videokey, videoBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
}
#pragma mark-get
-(VideoBlock)videoBlock
{
    return objc_getAssociatedObject(self, &videokey);
}
- (PhotoBlock )photoBlock
{
    return objc_getAssociatedObject(self, &blockKey);
}
-(void)showCanEdit:(BOOL)edit photo:(PhotoBlock)block isTakeCamera:(BOOL)isCamera
{
    if(edit) canEdit = edit;
    self.photoBlock = [block copy];
    [self clickForTabkePhoto:!isCamera];
}
-(void)showCanEdit:(BOOL)edit photo:(PhotoBlock)block
{
    if(edit) canEdit = edit;
    
    self.photoBlock = [block copy];
    UIActionSheet *sheet  = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照", @"相册中获取", nil];
    sheet.tag = 2599;
    [sheet showInView:self.view];
    
}

-(void)clickForTabkePhoto:(NSInteger)buttonIndex{
    //权限
    ALAuthorizationStatus author = [ALAssetsLibrary authorizationStatus];
    if (author == ALAuthorizationStatusRestricted || author ==ALAuthorizationStatusDenied) {
        NSString *photoType = buttonIndex==0?@"相机":@"相册";
        NSString * title = [NSString stringWithFormat:@"%@权限未开启",photoType];
        NSString * msg = [NSString stringWithFormat:@"请在系统设置中开启该应用%@服务\n(设置->隐私->%@->开启)",photoType,photoType];
        NSString * cancelTitle = @"知道了";
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title message:msg delegate:self cancelButtonTitle:cancelTitle otherButtonTitles:@"设置", nil];
        [alertView show];
        debugLog(@"%@权限未开启",photoType);
        return;
    }
    
    UIImagePickerController* imagePickerController = [[UIImagePickerController alloc] init];
    imagePickerController.delegate = self;
    imagePickerController.allowsEditing = canEdit;
    switch (buttonIndex)
    {
        case 0:
            //拍照
            //是否支持相机
            if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
            {
                imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
                [self presentViewController:imagePickerController animated:YES completion:NULL];
            }
            else
            {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"该设备不支持相机" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:@"设置", nil];
                [alert show];
            }
            break;
        case 1:
            //相册
            imagePickerController.sourceType =UIImagePickerControllerSourceTypePhotoLibrary;
            [self presentViewController:imagePickerController animated:YES completion:NULL];
        default:
            break;
    }
    
}
#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) { // 去设置界面，开启相机访问权限
        if (iOS8Later) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
        }
    }
}

#pragma mark - action sheet delegte
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    //权限
    ALAuthorizationStatus author = [ALAssetsLibrary authorizationStatus];
    if (author == ALAuthorizationStatusRestricted || author ==ALAuthorizationStatusDenied) {
        NSString *photoType = buttonIndex==0?@"相机":@"相册";
        NSString * title = [NSString stringWithFormat:@"%@权限未开启",photoType];
        NSString * msg = [NSString stringWithFormat:@"请在系统设置中开启该应用%@服务\n(设置->隐私->%@->开启)",photoType,photoType];
        NSString * cancelTitle = @"知道了";
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title message:msg delegate:self cancelButtonTitle:cancelTitle otherButtonTitles:@"设置", nil];
        [alertView show];
        debugLog(@"%@权限未开启",photoType);
        return;
    }
    if (actionSheet.tag==2599)
    {
        //跳转到相机/相册页面
        UIImagePickerController* imagePickerController = [[UIImagePickerController alloc] init];
        imagePickerController.delegate = self;
        imagePickerController.allowsEditing = canEdit;
        switch (buttonIndex)
        {
            case 0:
                //拍照
                //是否支持相机
                if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
                {
                    imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
                    [self presentViewController:imagePickerController animated:YES completion:NULL];
                }
                else
                {
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"该设备不支持相机" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                    [alert show];
                }
                break;
            case 1:
                //相册
                imagePickerController.sourceType =UIImagePickerControllerSourceTypePhotoLibrary;
                [self presentViewController:imagePickerController animated:YES completion:NULL];
            default:
                break;
        }
    }
}
#pragma mark - image picker delegte
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [picker dismissViewControllerAnimated:YES completion:^{}];
    
    UIImage *image;
    //是否要裁剪
    if ([picker allowsEditing]){
        
        //编辑之后的图像
        image = [info objectForKey:UIImagePickerControllerEditedImage];
        
    } else {
        
        image = [info objectForKey:UIImagePickerControllerOriginalImage];
    }
    
    if(self.photoBlock)
    {
        self.photoBlock(image);
    }
}
-(void)showCustomCanEdit:(BOOL)edit photo:(PhotoBlock)block isTakeCamera:(BOOL)isCamera
{
    if(edit) canEdit = edit;
    self.photoBlock = [block copy];
    TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:1 delegate:nil];
#pragma mark - 四类个性化设置，这些参数都可以不传，此时会走默认设置
    imagePickerVc.photoWidth = 1000;
    // 1.如果你需要将拍照按钮放在外面，不要传这个参数
//    imagePickerVc.selectedAssets = assistArr; // optional, 可选的
    imagePickerVc.allowTakePicture = isCamera; // 在内部显示拍照按钮
    // 2. Set the appearance
    // 2. 在这里设置imagePickerVc的外观
    // imagePickerVc.navigationBar.barTintColor = [UIColor greenColor];
    imagePickerVc.oKButtonTitleColorDisabled = [UIColor lightGrayColor];
    //        imagePickerVc.oKButtonTitleColorNormal = [Utils colorConvertFromString:@"#00c0ff"];
    // 3. Set allow picking video & photo & originalPhoto or not
    // 3. 设置是否可以选择视频/图片/原图
    imagePickerVc.allowPickingVideo = NO;
    imagePickerVc.allowPickingImage = YES;
    imagePickerVc.allowPickingOriginalPhoto = NO;
    // 4. 照片排列按修改时间升序
    imagePickerVc.sortAscendingByModificationDate = NO;
    /*
     @property (nonatomic, assign) BOOL allowCrop;       ///< 允许裁剪,默认为YES，showSelectBtn为NO才生效
     @property (nonatomic, assign) CGRect cropRect;      ///< 裁剪框的尺寸
     @property (nonatomic, assign) BOOL needCircleCrop;  ///< 需要圆形裁剪框
     @property (nonatomic, assign) NSInteger circleCropRadius;  ///< 圆形裁剪框半径大小
     */
    imagePickerVc.allowCrop = YES;
    CGFloat width = (ScreenWidth-40)*0.5;
    imagePickerVc.cropRect = CGRectMake(ScreenWidth/2.0-width, ScreenHeight/2.0-width, ScreenWidth - 40, ScreenWidth - 40);
#pragma mark - 到这里为止
    
    // You can get the photos by block, the same as by delegate.
    // 你可以通过block或者代理，来得到用户选择的照片.
    WS()
    [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
        if(weakSelf.photoBlock)
        {
            weakSelf.photoBlock(photos.firstObject);
        }
    }];
    [self presentViewController:imagePickerVc animated:YES completion:nil];

}
#pragma clang diagnostic pop
@end
