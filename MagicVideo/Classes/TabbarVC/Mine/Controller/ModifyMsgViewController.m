//
//  ModifyMsgViewController.m
//  KSMovie
//
//  Created by young He on 2018/9/20.
//  Copyright © 2018年 youngHe. All rights reserved.
//

#import "ModifyMsgViewController.h"
#import "UILabel+Category.h"
#import "UIButton+Category.h"
#import "LCActionSheet.h"

#import "HXPhotoManager.h"
#import "TZImagePickerController.h"
#import "TZImageManager.h"
#import "UIViewController+ImagePicker.h"
#import "UIViewController+HXExtension.h"
#import "HXCustomCameraController.h"
#import "HXCustomCameraViewController.h"
#import "HXDatePhotoEditViewController.h"
#import "PrivacyPermission.h"
#import "QNImageUploader.h"

@interface ModifyMsgViewController ()
<UITextFieldDelegate,
LCActionSheetDelegate,
TZImagePickerControllerDelegate,
UIImagePickerControllerDelegate,
HXCustomCameraViewControllerDelegate,
HXDatePhotoEditViewControllerDelegate>

@property (nonatomic,weak) UIImageView *iconIV;
@property (nonatomic,weak) UITextField *inputTF;
@property (nonatomic,strong) HXPhotoManager *manager;
@property (nonatomic,strong) NSMutableArray *selectedAssets;
@property (nonatomic,strong) NSMutableArray *selectedPhotos;
//@property (nonatomic,strong) UploadMsgModel *uploadModel;
@end

@implementation ModifyMsgViewController

//- (UploadMsgModel *)uploadModel {
//    if (!_uploadModel) {
//        _uploadModel = [[UploadMsgModel alloc]init];
//    }return _uploadModel;
//}

-(NSMutableArray *)selectedPhotos {
    if(_selectedPhotos == nil){
        _selectedPhotos = [NSMutableArray array];
    }return _selectedPhotos;
}

-(NSMutableArray *)selectedAssets{
    if(_selectedAssets == nil){
        _selectedAssets  = [NSMutableArray array];
    }return _selectedAssets;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"用户信息";
    self.fd_interactivePopDisabled = YES;
    self.fd_prefersNavigationBarHidden = YES;
    [self createUI];
}

- (void)backAction {
//    if (self.uploadModel.isSuccess || ![self.inputTF.text isEqualToString:[USER_MANAGER getUserNickName]]) {
//        [self saveAction];
//    }else {
        [self.navigationController popViewControllerAnimated:YES];
//    }
}

- (void)createUI {
    UIImageView *bgIV = [[UIImageView alloc]initWithImage:Image_Named(@"loginBG")];
    bgIV.contentMode = UIViewContentModeScaleAspectFill;
    [self.view addSubview:bgIV];
    [bgIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    UIButton *backBtn = [UIButton buttonWithImage:Image_Named(@"back_login") selectedImage:Image_Named(@"back_login")];
    [backBtn addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backBtn];
    [backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(self.sizeH(40));
        make.left.equalTo(self.view).offset(self.sizeW(5));
        make.width.height.equalTo(self.sizeW(50));
    }];
    
    UIImageView *iconIV = [[UIImageView alloc]init];
    iconIV.layer.masksToBounds = YES;
    iconIV.contentMode = UIViewContentModeScaleAspectFill;
    iconIV.image = img_placeHolder;
    iconIV.userInteractionEnabled = YES;
    if ([USER_MANAGER getUserIcon].length>0) {
        [iconIV sd_setImageWithURL:URL([USER_MANAGER getUserIcon]) placeholderImage:img_placeHolderIcon options:SDWebImageRetryFailed];
    }else {
        iconIV.image = img_placeHolderIcon;
    }
    [self.view addSubview:iconIV];
    self.iconIV = iconIV;
    self.iconIV.layer.cornerRadius = self.sizeH(45);
    self.iconIV.layer.borderColor = White_Color.CGColor;
    self.iconIV.layer.borderWidth = self.sizeH(4);
    [self.iconIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.view).offset([self contentOffset]+self.sizeH(50));
        make.width.height.equalTo(self.sizeH(90));
    }];
    
    UIView *line1 = [[UIView alloc]init];
    line1.backgroundColor = KCOLOR(@"#F8F8F8");
    [self.view addSubview:line1];
    [line1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.iconIV.mas_bottom).offset(self.sizeH(50));
        make.left.right.equalTo(self.view);
        make.height.equalTo(0.7f);
    }];
    
    UILabel *lab = [UILabel labelWithTitle:@"昵称" font:16 textColor:color_defaultText textAlignment:0];
    [self.view addSubview:lab];
    [lab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(self.sizeW(12));
        make.top.equalTo(line1.mas_bottom).offset(self.sizeH(10));
        make.width.equalTo(self.sizeW(80));
        make.height.equalTo(self.sizeH(25));
    }];
    
    UITextField *inputTF = [[UITextField alloc]init];
    inputTF.delegate = self;
    inputTF.font = Font_Size(15);
    inputTF.textColor = White_Color;
    inputTF.textAlignment = NSTextAlignmentLeft;
    inputTF.keyboardType = UIKeyboardTypeDefault;
    inputTF.text = [USER_MANAGER getUserNickName];
    [self.view addSubview:inputTF];
    self.inputTF = inputTF;
    [self.inputTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(lab.mas_right).offset(5);
        make.right.equalTo(self.view).offset(self.sizeW(-12));
        make.centerY.height.equalTo(lab);
    }];
    
    UIToolbar * topView = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 40)];
    [topView setBarStyle:0];
    topView.backgroundColor = [UIColor whiteColor];
    UIBarButtonItem * btnSpace = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(2, 5, 50, 25);
    [btn addTarget:self action:@selector(dismissKeyBoard) forControlEvents:UIControlEventTouchUpInside];
    [btn setTitleColor:DarkGray_Color forState:UIControlStateNormal];
    [btn setTitle:@"完成"forState:UIControlStateNormal];
    UIBarButtonItem *doneBtn = [[UIBarButtonItem alloc]initWithCustomView:btn];
    NSArray * buttonsArray = [NSArray arrayWithObjects:btnSpace,doneBtn,nil];
    [topView setItems:buttonsArray];
    [self.inputTF setInputAccessoryView:topView];
    
    UIView *line2 = [[UIView alloc]init];
    line2.backgroundColor = KCOLOR(@"#F8F8F8");
    [self.view addSubview:line2];
    [line2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lab.mas_bottom).offset(self.sizeH(10));
        make.left.right.equalTo(self.view);
        make.height.equalTo(0.7f);
    }];
    
    UIButton *okBtn = [UIButton buttonWithTitle:@"退出登录" titleColor:White_Color bgColor:KCOLOR(@"#D96139") highlightedColor:White_Color];
    okBtn.showsTouchWhenHighlighted = NO;
    [okBtn addTarget:self action:@selector(saveAction) forControlEvents:UIControlEventTouchUpInside];
    okBtn.layer.masksToBounds = YES;
    okBtn.layer.cornerRadius = self.sizeH(5);
    [self.view addSubview:okBtn];
    [okBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(line2.mas_bottom).offset(self.sizeH(10));
        make.left.equalTo(lab);
        make.right.equalTo(self.inputTF);
        make.height.equalTo(self.sizeH(40));
    }];
    
    UITapGestureRecognizer *gesture1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    [self.iconIV addGestureRecognizer:gesture1];
 
}

#pragma mark - 完成按钮事件
- (void)saveAction {
    
    
    //暂时 退出登录
    //暂时 退出登录
   
    //    //无论退出还是登录, 都清空未读消息数
    //    [USER_MANAGER notiPushNumberClearWithType:NotiType_All];
    //    //无论退出还是登录, 都清空首页热门的请求参数数组
    //    [USERDEFAULTS removeObjectForKey:@"HomeHotRequestArr"];
    //    [USERDEFAULTS synchronize];
    
    if (IS_LOGIN) {
        
        //        //个推: 解绑用户别名
        //        [g_App bindGeTuiWithIsBind:NO];
        
        [USER_MANAGER removeUserAllData];
        SSMBToast(@"退出登录成功",MainWindow);
        [self.navigationController popViewControllerAnimated:YES];
    }
    
    
    
//    [self.view endEditing:YES];
//    NSString *iconUrl = @"";
//    NSString *nameStr = @"";
//    if (self.inputTF.text.length==0) {
//        SSMBToast(@"昵称不能为空", MainWindow);
//        return;
//    }else {
//        nameStr = self.inputTF.text;
//    }
//    if (self.uploadModel.isSuccess) {
//        iconUrl = self.uploadModel.url;
//    }else {
//        if ([USER_MANAGER getUserIcon].length>0) {
//            iconUrl = [USER_MANAGER getUserIcon];
//        }
//    }
//
//    SSGifShow(MainWindow, @"正在保存");
//    NSDictionary *dic = @{@"nickName" : nameStr,
//                          @"portrait" : iconUrl
//                          };
//    [[SSRequest request]POSTAboutLogin:ModifyUerMsgUrl parameters:dic.mutableCopy success:^(SSRequest *request, id response)
//    {
//        SSDissMissAllGifHud(MainWindow, YES);
//        [USER_MANAGER reloadAvatar:iconUrl];
//        [USER_MANAGER reloadNickName:nameStr];
//        [NOTIFICATION postNotificationName:RefreshUserMsgNoti object:nil];
//        [self.navigationController popViewControllerAnimated:YES];
//
//    } failure:^(SSRequest *request, NSString *errorMsg) {
//        SSDissMissAllGifHud(MainWindow, YES);
//        SSMBToast(errorMsg, MainWindow);
//        [self.navigationController popViewControllerAnimated:YES];
//    }];
}

- (void)handleTap:(UITapGestureRecognizer *)gesture {
    LCActionSheet * actionSheet = [[LCActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"从相册中选择",@"拍照",nil];
    actionSheet.buttonFont = Font_Size(16);
    actionSheet.buttonColor = Black_Color;
    [actionSheet show];
}

#pragma mark - LCActionSheetDelegate
-(void)actionSheet:(LCActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex {
    switch (buttonIndex) {
        case 1:   //从相册中选择
        {
            [self pushImagePickerController];
        }
            break;
        case 2:   //拍照
        {
            [self takeCamera];
        }
            break;
        default:
            break;
    }
}

#pragma mark - 拍照
-(void)takeCamera {
    WS()
    [[PrivacyPermission sharedInstance]accessPrivacyPermissionWithType:PrivacyPermissionTypeCamera completion:^(BOOL response, PrivacyPermissionAuthorizationStatus status) {
        NSLog(@"response:%d \n status:%ld",response,status);
        if(response) {
            [weakSelf hx_presentCustomCameraViewControllerWithManager:weakSelf.manager delegate:weakSelf];
        }else {
            [weakSelf authorForCameraOrPhoto:YES];
        }
    }];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    if ([picker isKindOfClass:[UIImagePickerController class]]) {
        [picker dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void)customCameraViewController:(HXCustomCameraViewController *)viewController didDone:(HXPhotoModel *)model {
    [viewController dismissViewControllerAnimated:YES completion:nil];
    WS()
    [[PrivacyPermission sharedInstance]accessPrivacyPermissionWithType:PrivacyPermissionTypePhoto completion:^(BOOL response, PrivacyPermissionAuthorizationStatus status) {
        NSLog(@"response:%d \n status:%ld",response,status);
        if(response) {
            [weakSelf resolveCameraModel:model];
        }else {
            [weakSelf authorForCameraOrPhoto:YES];
        }
    }];
}

-(void)resolveCameraModel:(HXPhotoModel*)model {
    TZImagePickerController *tzImagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:1 delegate:self];
    SSGifShow(MainWindow, @"处理中...");
    UIImage *image = model.previewPhoto;
    WS()
    // save photo and get asset / 保存图片，获取到asset
    [[TZImageManager manager] savePhotoWithImage:image location:nil completion:^(NSError *error){
        SSDissMissAllGifHud(MainWindow, YES);
        if (error) {
            SSMBToast(@"图片保存失败", nil);
            NSLog(@"图片保存失败 %@",error);
        } else {
            [[TZImageManager manager] getCameraRollAlbum:NO allowPickingImage:YES completion:^(TZAlbumModel *model) {
                [[TZImageManager manager] getAssetsFromFetchResult:model.result allowPickingVideo:NO allowPickingImage:YES completion:^(NSArray<TZAssetModel *> *models) {
                    TZAssetModel *assetModel = [models firstObject];
                    if (tzImagePickerVc.sortAscendingByModificationDate) {
                        assetModel = [models lastObject];
                    }
                    // 允许裁剪,去裁剪
                    TZImagePickerController *imagePicker = [[TZImagePickerController alloc] initCropTypeWithAsset:assetModel.asset photo:image completion:^(UIImage *cropImage, id asset) {
                        [weakSelf ossUploadWithImage:cropImage];
                    }];
                    imagePicker.allowCrop = YES;
                    imagePicker.cropRect = CGRectMake(0, (ScreenHeight-ScreenWidth)/2.0, ScreenWidth, ScreenWidth);
                    [weakSelf presentViewController:imagePicker animated:YES completion:nil];
                    
                }];
            }];
        }
    }];
}

#pragma mark - 从相册选
#pragma mark - TZImagePickerController
- (void)pushImagePickerController {
        WS()
        [self pickImageNum:1 andFinish:^(NSArray *imageArr, NSArray *assistArr) {
            weakSelf.selectedAssets = [NSMutableArray arrayWithArray:assistArr];
            weakSelf.selectedPhotos = [NSMutableArray arrayWithArray:imageArr];
            [weakSelf ossUploadWithImage:imageArr.firstObject];
        } withAssistArr:self.selectedAssets allowCrop:YES];
}

- (void)ossUploadWithImage:(UIImage *)img {
//    SSGifShow(MainWindow, @"加载中");
//    NSDictionary *dic = @{@"type" : @"QNT001"};
//    [[SSRequest request]GET:GetImgUpdateTokenUrl parameters:dic.mutableCopy success:^(SSRequest *request, id response) {
//
//        SSDissMissAllGifHud(MainWindow, YES);
//        self.uploadModel = [UploadMsgModel mj_objectWithKeyValues:response[@"data"]];
//        self.uploadModel.uploadImg = img;
//        SSLog(@"%@",response);
//        [self qnUpload];
//
//    } failure:^(SSRequest *request, NSString *errorMsg) {
//        SSDissMissAllGifHud(MainWindow, YES);
//        SSMBToast(errorMsg, MainWindow);
//    }];
    
}

- (void)qnUpload {
//    SSGifShow(MainWindow, @"上传中");
//    WS()
//    [QNImageUploader uploadImageWithModel:self.uploadModel complete:^(NSString *name, UploadImageState state) {
//        SSDissMissAllGifHud(MainWindow, YES);
//        if (state == UploadImageSuccess) {
//            weakSelf.uploadModel.isSuccess = YES;
//            weakSelf.iconIV.image = self.uploadModel.uploadImg;
//        }else {
//            weakSelf.uploadModel.isSuccess = NO;
//            if ([USER_MANAGER getUserIcon].length>0) {
//                [weakSelf.iconIV sd_setImageWithURL:URL([USER_MANAGER getUserIcon]) placeholderImage:img_placeHolderIcon options:SDWebImageRetryFailed];
//            }else {
//                weakSelf.iconIV.image = img_placeHolderIcon;
//            }
//            SSMBToast(@"上传失败,请重新选取图片", MainWindow);
//        }
//    }];
}

- (HXPhotoManager *)manager {
    if (!_manager) {
        _manager = [[HXPhotoManager alloc] initWithType:HXPhotoManagerSelectedTypePhoto];
        _manager.configuration.openCamera = YES;
        _manager.configuration.saveSystemAblum = NO;
        _manager.configuration.themeColor = [UIColor blackColor];
    }return _manager;
}

- (void)dismissKeyBoard {
    [self.view endEditing:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
