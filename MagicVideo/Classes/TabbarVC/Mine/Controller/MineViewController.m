//
//  MineViewController.m
//  MagicVideo
//
//  Created by young He on 2019/9/18.
//  Copyright © 2019年 youngHe. All rights reserved.
//

#import "MineViewController.h"
#import "MineTableViewCell.h"
#import "MineTableViewHeaderView.h"
#import "ModifyMsgViewController.h"

//#import "HistoryViewController.h"
//#import "ErrorReportViewController.h"
//#import "MsgCenterController.h"
//#import "CollectViewController.h"

@interface MineViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *mainTableView;
@property (nonatomic, copy) NSMutableArray<NSArray *> *dataArray;
@property (nonatomic, weak) MineTableViewHeaderView *headerView;
@end

@implementation MineViewController

static NSString * const cellID = @"MineTableViewCell";
static NSString * const cellHeader_ID = @"cellHeader_ID";

- (NSMutableArray<NSArray *> *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSMutableArray arrayWithCapacity:5];
        NSArray *nameArr = @[@"观看历史",@"我的收藏",@"消息中心",@"我的钱包",@"意见反馈",@"QQ粉丝群",@"联系我们"];
        NSArray *imgNameArr = @[@"ic_watchHistory_mine",@"ic_collect_mine",@"ic_msgCenter",@"ic_myWallet",@"ic_advice",@"ic_qq",@"ic_connectUs"];
        
        NSMutableArray<MineTVCellModel *> *arr1 = [NSMutableArray array];
        NSMutableArray<MineTVCellModel *> *arr2 = [NSMutableArray array];
        for (int i = 0; i<nameArr.count; i++) {
            MineTVCellModel *m = [[MineTVCellModel alloc]init];
            m.imgName = imgNameArr[i];
            m.title = nameArr[i];
            if (i<4) {
                [arr1 addObject:m];
            }else {
                [arr2 addObject:m];
            }
        }
        [_dataArray addObject:[arr1 copy]];
        [_dataArray addObject:[arr2 copy]];
    }return _dataArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.fd_prefersNavigationBarHidden = YES;
    [self createUI];
    [NOTIFICATION addObserver:self selector:@selector(refreshUserMsg) name:RefreshUserMsgNoti object:nil];
}

- (void)refreshUserMsg {
    [self.headerView refresh];
}

- (void)createUI {
    [self.view addSubview:self.mainTableView];
    [self.mainTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray[section].count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MineTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID forIndexPath:indexPath];
    cell.model = self.dataArray[indexPath.section][indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section==0) {
        switch (indexPath.row) {
            case 0:  //观看历史
            {
//                HistoryViewController *vc = [[HistoryViewController alloc]init];
//                vc.hidesBottomBarWhenPushed = YES;
//                [self.navigationController pushViewController:vc animated:YES];
            }
                break;
            case 1:  //我的收藏
            {
//                CollectViewController *vc = [[CollectViewController alloc]init];
//                vc.hidesBottomBarWhenPushed = YES;
//                [self.navigationController pushViewController:vc animated:YES];
            }
                break;
            case 2: //消息中心
            {
//                MsgCenterController *vc = [[MsgCenterController alloc]init];
//                vc.hidesBottomBarWhenPushed = YES;
//                [self.navigationController pushViewController:vc animated:YES];
            }
                break;
            case 3: //我的钱包
            {
                UIViewController *controller = g_App.window.rootViewController;
                KSTabBarController *rvc = (KSTabBarController *)controller;
                [rvc setSelectedIndex:2];
                [self.navigationController popToRootViewControllerAnimated:YES];
            }
                break;
            default:
                break;
        }
    }else if (indexPath.section==1) {
        switch (indexPath.row) {
            case 0: //意见反馈
            {
//                ErrorReportViewController *vc = [[ErrorReportViewController alloc]init];
//                vc.hidesBottomBarWhenPushed = YES;
//                [self.navigationController pushViewController:vc animated:YES];
            }
                break;
            case 1: //QQ粉丝群
            {
//                KSBaseWebViewController *webView = [[KSBaseWebViewController alloc]init];
//                webView.webType = WKType;
//                webView.isHaveInteration = YES;
//                webView.titleStr = @"影视部落交流群";
//                webView.bannerUrl = [USER_MANAGER isDevStatus] ? SSStr(DevServerURL_H5, QQFansH5_Url) : SSStr(ServerURL_H5, QQFansH5_Url);
//                webView.hidesBottomBarWhenPushed = YES;
//                [self.navigationController pushViewController:webView animated:YES];
            }
                break;
            case 2: //联系我们
            {
//                KSBaseWebViewController *webView = [[KSBaseWebViewController alloc]init];
//                webView.webType = WKType;
//                webView.isHaveInteration = YES;
//                webView.titleStr = @"联系我们";
//                webView.bannerUrl = [USER_MANAGER isDevStatus] ? SSStr(DevServerURL_H5, ConnectUsH5_Url) : SSStr(ServerURL_H5, ConnectUsH5_Url);
//                webView.hidesBottomBarWhenPushed = YES;
//                [self.navigationController pushViewController:webView animated:YES];
            }
                break;
            default:
                break;
        }
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section==1) {
        UIView *header = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, self.sizeH(10))];
        header.backgroundColor = KCOLOR(@"#f8f8f8");
        return header;
    }else {
        return [[UIView alloc]init];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return (section==1) ? self.sizeH(10) : 0.01;
}

#pragma mark - lazyLoad
- (UITableView *)mainTableView {
    if (!_mainTableView) {
        _mainTableView = [[UITableView alloc] initWithFrame:CGRectZero style:(UITableViewStylePlain)];
        _mainTableView.delegate = self;
        _mainTableView.dataSource = self;
        _mainTableView.bounces = NO;
        _mainTableView.backgroundColor = White_Color;
        [_mainTableView registerClass:[MineTableViewCell class] forCellReuseIdentifier:cellID];
        _mainTableView.rowHeight = self.sizeW(48);
        _mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
      
        MineTableViewHeaderView *headerView = [[MineTableViewHeaderView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, self.sizeH(180))];
        WS()
        headerView.modifyMsgBlock = ^{
            if (IS_LOGIN) {
                ModifyMsgViewController *vc = [[ModifyMsgViewController alloc]init];
                vc.hidesBottomBarWhenPushed = YES;
                [weakSelf.navigationController pushViewController:vc animated:YES];
            }else {
                [USER_MANAGER gotoLoginFromVC:weakSelf];
            }
        };
        
        self.headerView = headerView;
        _mainTableView.tableHeaderView = self.headerView;

    }return _mainTableView;
}

@end
