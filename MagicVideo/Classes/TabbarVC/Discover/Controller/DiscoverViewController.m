//
//  DiscoverViewController.m
//  MagicVideo
//
//  Created by young He on 2019/9/18.
//  Copyright © 2019年 youngHe. All rights reserved.
//

#import "DiscoverViewController.h"
#import "WatchPointCell.h"
#import "MYHRocketHeader.h"
#import <DZNEmptyDataSet/UIScrollView+EmptyDataSet.h>
#import "HomeViewController.h"

@interface DiscoverViewController ()<UITableViewDelegate,UITableViewDataSource,DZNEmptyDataSetSource,DZNEmptyDataSetDelegate>

@property (nonatomic, strong) UITableView *mainTableView;
//@property (nonatomic,strong) NSMutableArray<SubjectListModel *> *dataArr;
@property (nonatomic,strong) NSMutableArray *dataArr;
@property (nonatomic,assign) NSInteger page;

@end

@implementation DiscoverViewController

static NSString * const cellID = @"WatchPointCell";

- (NSMutableArray *)dataArr {
    if (!_dataArr) {
        _dataArr = [NSMutableArray array];
        [_dataArr addObjectsFromArray:@[@"",@"",@"",@"",@"",@"",@"",@"",@"",@""]];
    }return _dataArr;
}

//- (NSMutableArray<SubjectListModel *> *)dataArr {
//    if (!_dataArr) {
//        _dataArr = [NSMutableArray array];
//    }return _dataArr;
//}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.fd_prefersNavigationBarHidden = YES;
    self.page = 0;
    [self.view addSubview:self.mainTableView];
    [self.mainTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo([self statusBarHeight]);
        make.left.right.bottom.equalTo(self.view);
    }];
    [self loadDateWithAnimation:YES];
}

- (void)loadDateWithAnimation:(BOOL)isAnimation {
    if (isAnimation) {
        SSGifShow(MainWindow, @"加载中");
    }
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (isAnimation) {
            SSDissMissAllGifHud(MainWindow, YES);
        }
        self.isNetError = SSNetNormal_state;
        [self.mainTableView.mj_header endRefreshing];
        [self.mainTableView.mj_footer endRefreshing];

         [self.mainTableView reloadData];
    });
    
    //    NSDictionary *dic = @{@"si": self.model.idForModel,
    //                          @"index" : @(self.page),
    //                          @"size" : @(PageCount_Normal)
    //                          };
    //    [[SSRequest request]GET:WatchPointUrl parameters:dic.mutableCopy success:^(SSRequest *request, id response) {
    //
    //        if (isAnimation) {
    //            SSDissMissAllGifHud(MainWindow, YES);
    //        }
    //
    //        self.isNetError = SSNetNormal_state;
    //        [self.mainTableView.mj_header endRefreshing];
    //
    //        if(self.page == 0 && (self.dataArr.count>0)) {
    //            [self.dataArr removeAllObjects];
    //        }
    //
    //        NSArray *arr = [SubjectListModel mj_objectArrayWithKeyValuesArray:response[@"data"]];
    //
    //        [self.dataArr addObjectsFromArray:arr];
    //
    //        if (arr.count == 0) {
    //            [self.mainTableView.mj_footer endRefreshingWithNoMoreData];
    //        }else {
    //            [self.mainTableView.mj_footer endRefreshing];
    //        }
    //
    //        [self.mainTableView reloadData];
    //
    //    } failure:^(SSRequest *request, NSString *errorMsg) {
    //        if (isAnimation) {SSDissMissAllGifHud(MainWindow, YES);}
    //        SSMBToast(errorMsg, MainWindow);
    //        self.isNetError = SSNetError_state;
    //        [self.mainTableView reloadData];
    //        [self.mainTableView.mj_header endRefreshing];
    //        [self.mainTableView.mj_footer endRefreshing];
    //    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    WatchPointCell *cell = [WatchPointCell cellForTableView:tableView];
//    cell.model = self.dataArr[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//    SubjectListModel *m = self.dataArr[indexPath.row];
    HomeViewController *vc = [[HomeViewController alloc]init];
//    vc.model = m;
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - lazyLoad
- (UITableView *)mainTableView {
    if (!_mainTableView) {
        _mainTableView = [[UITableView alloc] initWithFrame:CGRectZero style:(UITableViewStylePlain)];
        _mainTableView.delegate = self;
        _mainTableView.dataSource = self;
        _mainTableView.emptyDataSetSource = self;
        _mainTableView.emptyDataSetDelegate = self;
        _mainTableView.backgroundColor = KCOLOR(@"#ffffff");
        _mainTableView.showsVerticalScrollIndicator = NO;
        [_mainTableView registerClass:[WatchPointCell class] forCellReuseIdentifier:cellID];
        _mainTableView.rowHeight = self.sizeH(240);
        _mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        WS()
        _mainTableView.mj_header = [MYHRocketHeader headerWithRefreshingBlock:^{
            weakSelf.page = 0;
            [weakSelf loadDateWithAnimation:NO];
        }];
        _mainTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
            weakSelf.page ++;
            [weakSelf loadDateWithAnimation:NO];
        }];
    }return _mainTableView;
}


#pragma mark--DZ
-(UIImage*)imageForEmptyDataSet:(UIScrollView *)scrollView {
    if(self.isNetError==SSNetLoading_state)return nil;
    return self.isNetError == SSNetNormal_state ? Image_Named(@"netError") : Image_Named(@"netError");
}

-(NSAttributedString*)titleForEmptyDataSet:(UIScrollView *)scrollView {
    if(self.isNetError==SSNetLoading_state)return nil;
    NSString *text = self.isNetError==SSNetError_state?@"网络请求失败":@"暂无数据";
    NSDictionary *attribute = self.isNetError?@{NSFontAttributeName: [UIFont systemFontOfSize:18.0f], NSForegroundColorAttributeName: KCOLOR(@"#333333")}:@{NSFontAttributeName: [UIFont systemFontOfSize:18.0f], NSForegroundColorAttributeName: KCOLOR(@"#999999")};
    return [[NSAttributedString alloc] initWithString:text attributes:attribute];
}

// 返回详情文字
- (NSAttributedString *)descriptionForEmptyDataSet:(UIScrollView *)scrollView {
    if(self.isNetError!=SSNetError_state)return nil;
    NSString *text = @"加载失败,点击重试";
    NSDictionary *attribute = @{NSFontAttributeName: [UIFont systemFontOfSize:12.0f], NSForegroundColorAttributeName: KCOLOR(@"#999999")};
    return [[NSAttributedString alloc] initWithString:text attributes:attribute];
}

-(UIImage*)buttonImageForEmptyDataSet:(UIScrollView *)scrollView forState:(UIControlState)state
{
    if(self.isNetError!=SSNetError_state)return nil;
    return Image_Named(@"reload");
}

-(BOOL)emptyDataSetShouldAllowScroll:(UIScrollView *)scrollView {
    return YES;
}

- (void)emptyDataSet:(UIScrollView *)scrollView didTapView:(UIView *)view {
    self.isNetError = SSNetLoading_state;
    [self.mainTableView reloadEmptyDataSet];
    [self loadDateWithAnimation:YES];
}

- (BOOL)emptyDataSetShouldDisplay:(UIScrollView *)scrollView {
    return (self.dataArr.count==0);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
