//
//  SSPhotoListViewController.m
//  SmallStuff
//
//  Created by 闵玉辉 on 17/4/16.
//  Copyright © 2017年 yuhuimin. All rights reserved.
//

#import "SSPhotoListViewController.h"
#import "SSPhotoSelectViewController.h"
#import "TZImageManager.h"
#import "SSphotoListCell.h"
#import "UIView+MJExtension.h"
@interface SSPhotoListViewController ()
{
    NSTimer *_timer;
    UILabel *_tipLable;
    BOOL _pushToPhotoPickerVc;
}
@end

@implementation SSPhotoListViewController
-(instancetype)initWithAllowVideo:(BOOL)isAllowVideo allowImage:(BOOL)isAllowImage
{
    MYHAlbumPickerController *albumPickerVc = [[MYHAlbumPickerController alloc] init];
  if(self = [super initWithRootViewController:albumPickerVc])
  {
       [TZImageManager manager].photoPreviewMaxWidth  = 900;
      [TZImageManager manager].columnNumber =4;
      
      self.isSelectImg = isAllowImage;
      self.isSelectVideo = isAllowVideo;
      if (![[TZImageManager manager] authorizationStatusAuthorized]) {
          _tipLable = [[UILabel alloc] init];
          _tipLable.frame = CGRectMake(8, 0, self.view.mj_w - 16, 300);
          _tipLable.textAlignment = NSTextAlignmentCenter;
          _tipLable.numberOfLines = 0;
          _tipLable.font = [UIFont systemFontOfSize:16];
          _tipLable.textColor = [UIColor blackColor];
          NSString *appName = [[NSBundle mainBundle].infoDictionary valueForKey:@"CFBundleDisplayName"];
          if (!appName) appName = [[NSBundle mainBundle].infoDictionary valueForKey:@"CFBundleName"];
          _tipLable.text = [NSString stringWithFormat:@"请在%@的\"设置-隐私-照片\"选项中，\r允许%@访问你的手机相册。",[UIDevice currentDevice].model,appName];
          [self.view addSubview:_tipLable];
          
          _timer = [NSTimer scheduledTimerWithTimeInterval:0.2 target:self selector:@selector(observeAuthrizationStatusChange) userInfo:nil repeats:YES];
      } else {
          [self pushToPhotoPickerVc];
      }
  }
    return self;
}
- (void)observeAuthrizationStatusChange {
    if ([[TZImageManager manager] authorizationStatusAuthorized]) {
        [self pushToPhotoPickerVc];
        [_tipLable removeFromSuperview];
        [_timer invalidate];
        _timer = nil;
    }
}
- (void)pushToPhotoPickerVc {
    _pushToPhotoPickerVc = YES;
    if (_pushToPhotoPickerVc) {
        SSPhotoSelectViewController *photoPickerVc = [[SSPhotoSelectViewController alloc] init];
            [self pushViewController:photoPickerVc animated:YES];
            _pushToPhotoPickerVc = NO;
       
    }
}
- (void)setAllowPickingImage:(BOOL)allowPickingImage {
    _allowPickingImage = allowPickingImage;
    NSString *allowPickingImageStr = _allowPickingImage ? @"1" : @"0";
    [[NSUserDefaults standardUserDefaults] setObject:allowPickingImageStr forKey:@"tz_allowPickingImage"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)setAllowPickingVideo:(BOOL)allowPickingVideo {
    _allowPickingVideo = allowPickingVideo;
    NSString *allowPickingVideoStr = _allowPickingVideo ? @"1" : @"0";
    [[NSUserDefaults standardUserDefaults] setObject:allowPickingVideoStr forKey:@"tz_allowPickingVideo"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)setSortAscendingByModificationDate:(BOOL)sortAscendingByModificationDate {
    _sortAscendingByModificationDate = sortAscendingByModificationDate;
    [TZImageManager manager].sortAscendingByModificationDate = sortAscendingByModificationDate;
}

@end
@interface MYHAlbumPickerController ()<UITableViewDataSource,UITableViewDelegate> {
}
@property (nonatomic, strong) NSMutableArray *albumArr;
@property (nullable,weak) UITableView * tableView;
@property (nonatomic,strong) NSMutableArray * dataArray;
@end

@implementation MYHAlbumPickerController
-(NSMutableArray *)dataArray
{
    if(_dataArray == nil)
    {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = [Helper isAllowSelectVideo ]?@"所有视频":@"照片";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(cancel)];
    [self createUI];
    [self loadData];
}
-(void)cancel{
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if(_dataArray.count == 0)
    {
        if(_tableView == nil){[self createUI];};
        [self loadData];
    }
}
-(void)createUI{
    UITableView * tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
    tableView.delegate = self;
    tableView.dataSource = self;
    [tableView registerClass:[SSphotoListCell class] forCellReuseIdentifier:@"cell"];
    tableView.rowHeight = 70;
    tableView.tableFooterView = [UIView new];
    [self.view addSubview:tableView];
    self.tableView = tableView;
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}
-(void)loadData{
    WS()
    
    if([[TZImageManager manager]authorizationStatusAuthorized]){
     SSPhotoListViewController *imagePickerVc = (SSPhotoListViewController *)self.navigationController;
    MBProgressHUD * hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        
    [[TZImageManager manager] getAllAlbums:imagePickerVc.isSelectVideo allowPickingImage:imagePickerVc.isSelectImg completion:^(NSArray<TZAlbumModel *> *models) {
        [hud hide:YES];
        weakSelf.dataArray = [NSMutableArray arrayWithArray:models];
        [weakSelf.tableView reloadData];
    }];
    }
}
#pragma mark--
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SSphotoListCell * cell = [SSphotoListCell cellForTableView:tableView];
    cell.model = self.dataArray[indexPath.row];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    SSPhotoSelectViewController *photoPickerVc = [[SSPhotoSelectViewController alloc] init];
    TZAlbumModel *model = self.dataArray[indexPath.row];
    photoPickerVc.model = model;
    [self.navigationController pushViewController:photoPickerVc animated:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
