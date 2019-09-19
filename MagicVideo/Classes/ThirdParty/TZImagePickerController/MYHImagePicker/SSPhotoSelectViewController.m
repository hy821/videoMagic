//
//  SSPhotoSelectViewController.m
//  SmallStuff
//
//  Created by 闵玉辉 on 17/4/6.
//  Copyright © 2017年 yuhuimin. All rights reserved.
//

#import "SSPhotoSelectViewController.h"
#import "TZImageManager.h"
#import "UIView+Layout.h"
#import "TZAssetModel.h"
#import "SSPhotoCell.h"
#import "SSPhotoBrowerViewController.h"
#import "VPImageCropperViewController.h"
#import "SSPhotoListViewController.h"
#import "MBProgressHUD+MJ.h"
@interface SSPhotoSelectViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,VPImageCropperDelegate>
@property (nonatomic,strong) UICollectionView * collectionView;
@property (nonatomic,strong)  UILabel * tipLable;
@property (nonatomic,strong) NSTimer * timer;

//@property (nonatomic,strong) TZAlbumModel * model;
@property (nonatomic,strong) NSMutableArray * dataArr;
@end

@implementation SSPhotoSelectViewController
-(NSMutableArray *)dataArr
{
  if(_dataArr == nil)
  {
      _dataArr = [NSMutableArray array];
  }
    return _dataArr;
}
    static NSString * ID = @"ssPhoto";
- (void)viewDidLoad {
    [super viewDidLoad];
    [TZImageManager manager].photoPreviewMaxWidth  = 800;
//    [self setPresentVCBackBtn];
    self.title = self.model.name;
    [self loadData];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(cancel)];
//    if (![[TZImageManager manager] authorizationStatusAuthorized]) {
//        _tipLable = [[UILabel alloc] init];
//        _tipLable.frame = CGRectMake(8, 0, self.view.tz_width - 16, 300);
//        _tipLable.textAlignment = NSTextAlignmentCenter;
//        _tipLable.numberOfLines = 0;
//        _tipLable.font = [UIFont systemFontOfSize:16];
//        _tipLable.textColor = [UIColor blackColor];
//        NSString *appName = [[NSBundle mainBundle].infoDictionary valueForKey:@"CFBundleDisplayName"];
//        if (!appName) appName = [[NSBundle mainBundle].infoDictionary valueForKey:@"CFBundleName"];
//        _tipLable.text = [NSString stringWithFormat:@"请在%@的\"设置-隐私-照片\"选项中，\r允许%@访问你的手机相册。",[UIDevice currentDevice].model,appName];
//        [self.view addSubview:_tipLable];
//        
//        _timer = [NSTimer scheduledTimerWithTimeInterval:0.2 target:self selector:@selector(observeAuthrizationStatusChange) userInfo:nil repeats:YES];
//    } else {
//        [self loadData];
//    }
}
-(void)cancel{
    [self dismissViewControllerAnimated:YES completion:nil];
}
//- (void)observeAuthrizationStatusChange {
//    if ([[TZImageManager manager] authorizationStatusAuthorized]) {
//        [self loadData];
//        [_tipLable removeFromSuperview];
//        [_timer invalidate];
//        _timer = nil;
//    }
//}
-(void)createUI{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    CGFloat margin = 4;
    CGFloat itemWH = (self.view.tz_width - 2 * margin - 4) / 4 - margin;
    layout.itemSize = CGSizeMake(itemWH, itemWH);
    layout.minimumInteritemSpacing = margin;
    layout.minimumLineSpacing = margin;
    //  if (iOS7Later) top += 20;
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    //隐藏toolbar
    _collectionView.backgroundColor = [UIColor whiteColor];
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    _collectionView.alwaysBounceHorizontal = NO;
    _collectionView.scrollIndicatorInsets = UIEdgeInsetsMake(0, 0, 0, -2);
    [_collectionView registerClass:[SSPhotoCell class] forCellWithReuseIdentifier:ID];
    [self.view addSubview:_collectionView];
    [_collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.top.equalTo(self.view).offset([self contentOffset]);
    }];
}
-(void)loadData{

    [self createUI];
    if(self.model == nil)
    {
            WS()
            MBProgressHUD * hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            hud.labelText = @"正在加载...";
        SSPhotoListViewController * nav = (SSPhotoListViewController*)self.navigationController;
        [[TZImageManager manager] getCameraRollAlbum:nav.isSelectVideo allowPickingImage:nav.isSelectImg completion:^(TZAlbumModel *model) {
             [hud hide:YES];
            weakSelf.model = model;
            [weakSelf setTitle:model.name];
            weakSelf.dataArr = [NSMutableArray arrayWithArray:self.model.models];
            [weakSelf.collectionView reloadData];
        }];
    }else
    {
        self.dataArr = [NSMutableArray arrayWithArray:self.model.models];
        [self.collectionView reloadData];
    }

}
#pragma mark--collectionViewDelegate
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.dataArr.count;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    SSPhotoCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:ID forIndexPath:indexPath];
    cell.model = self.dataArr[indexPath.row];
    return cell;
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    TZAssetModel * model = self.dataArr[indexPath.row];
    TZImageManager * manager = [TZImageManager manager];
    WS()
    if(model.type == TZAssetModelMediaTypeVideo) {
        MBProgressHUD * hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        hud.mode = MBProgressHUDModeIndeterminate;
        hud.labelText=NSLocalizedString(@"正在导出视频...", @"HUD loading title");
        [manager getVideoOutputPathWithAsset:model.asset success:^(NSString *outputPath) {
           
            if(outputPath!=nil){
                [manager getPhotoWithAsset:model.asset completion:^(UIImage *photo, NSDictionary *info, BOOL isDegraded) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [hud hide:YES];
                        SSPhotoListViewController * nav = (SSPhotoListViewController*)weakSelf.navigationController;
                        [weakSelf dismissViewControllerAnimated:YES completion:^{
                            if(nav.didVideoFilePath)
                            {
                                nav.didVideoFilePath(outputPath,photo);
                            }
                        }];
                    });
                }];
                
            }else{
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    [hud hide:NO];
                    [MBProgressHUD showError:@"视频导出失败"];
                });
                
            }
            
        } failure:^(NSString *errorMessage, NSError *error) {
            
            [MBProgressHUD showError:errorMessage];
            
        }];
        
    }else {

            VPImageCropperViewController * vc = [[VPImageCropperViewController alloc]initWithImage:model cropFrame:CGRectMake(0,ScreenHeight/2.0-(ScreenHeight - 200)*0.5, ScreenWidth, ScreenHeight - 200) limitScaleRatio:3.0];
            vc.delegate = self;
            [weakSelf.navigationController pushViewController:vc animated:YES];

      }
}
-(void)imageCropperDidCancel:(VPImageCropperViewController *)cropperViewController
{
    [cropperViewController.navigationController popViewControllerAnimated:YES];
}
-(void)imageCropper:(VPImageCropperViewController *)cropperViewController didFinished:(UIImage *)editedImage
{
     SSPhotoListViewController * nav = (SSPhotoListViewController*)self.navigationController;
    if(nav.didFinishPickingPhotosHandle)
    {
        nav.didFinishPickingPhotosHandle(editedImage);
    }
    [cropperViewController dismissViewControllerAnimated:YES completion:nil];
}
-(void)dealloc
{
  if(self.timer)
  {
      [self.timer invalidate];
      self.timer = nil;
  }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
