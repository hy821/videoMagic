//
//  KSTabBarController.m
//  KSMovie
//
//  Created by young He on 2018/9/11.
//  Copyright © 2018年 youngHe. All rights reserved.
//

#import "KSTabBarController.h"
#import "KSBaseViewController.h"
#import "KSBaseNavViewController.h"
#import "KSTabBar.h"
#import "KSLayerAnimation.h"
#import "LoginViewController.h"

#import "HomeViewController.h"
#import "DiscoverViewController.h"
#import "WalletViewController.h"
#import "MineViewController.h"

@interface KSTabBarController ()<UITabBarControllerDelegate>
@property (nonatomic,assign) NSInteger indexFlag;

@end

@implementation KSTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configVC];
    self.delegate = self;
    KSTabBar *tabbar = [[KSTabBar alloc]init];
    [self setValue:tabbar forKeyPath:@"tabBar"];
}

-(void)configVC {
    NSArray *classNames = @[@"HomeViewController",@"DiscoverViewController",@"WalletViewController",@"MineViewController"];
    NSArray *titles = @[@"首页",@"发现",@"钱包",@"我的"];
    NSArray *normalImg = @[@"tab_HomeUn",@"tab_DiscoverUn",@"tab_WalletUn",@"tab_MineUn"];
    NSArray *selectImg = @[@"tab_Home",@"tab_Discover",@"tab_Wallet",@"tab_Mine"];
    
    for(int i=0;i<classNames.count;i++) {
        Class class=NSClassFromString(classNames[i]);
        KSBaseViewController * root=[[class alloc]init];
        [self addChildController:root title:titles[i] imageName:normalImg[i] selectedImageName:selectImg[i] navVc:[KSBaseNavViewController class]];
    }
}
- (void)addChildController:(UIViewController*)childController title:(NSString*)title imageName:(NSString*)imageName selectedImageName:(NSString*)selectedImageName navVc:(Class)navVc {
    
    childController.title = title;
    childController.tabBarItem.image = [[UIImage imageNamed:imageName] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    childController.tabBarItem.selectedImage = [[UIImage imageNamed:selectedImageName] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    // 设置一下选中tabbar文字颜色
    [childController.tabBarItem setTitleTextAttributes:@{ NSForegroundColorAttributeName : KCOLOR(@"#D96139") }forState:UIControlStateSelected];
    [childController.tabBarItem setTitleTextAttributes:@{ NSForegroundColorAttributeName : KCOLOR(@"#403632") }forState:UIControlStateNormal];
    UINavigationController * nav = [[navVc alloc] initWithRootViewController:childController];
    [self addChildViewController:nav];
}

-(UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait ;
}

- (BOOL)shouldAutorotate { //旋转
    return NO;
}

-(UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleDefault;
}

-(UIViewController*)childViewControllerForStatusBarStyle {
    UINavigationController * nav = self.selectedViewController;
    return nav.topViewController;
}

#pragma mark- UITabBarControllerDelegate
- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController {
//    NSInteger  index = [self.viewControllers indexOfObject:viewController];
//    BOOL isLogin = IS_LOGIN;
//    BOOL isNotOne = index==0?YES:NO;
//    if((!isLogin)&&(!isNotOne)){
//        self.indexFlag = 0;
//        [self gotoLogin];
//        return NO;
//
//    }else {
//        return YES;
//    }
    return YES;
}

-(void)gotoLogin {
    LoginViewController * login = [[LoginViewController alloc]init];
    [SelectVC pushViewController:login animated:YES];
}

- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item {
    
    NSInteger index = [self.tabBar.items indexOfObject:item];
    
//    [[BuryingPointManager shareManager] buryingPointWithEventID:BP_TabBarClick andParameters:@{BOTTOM_TAB_NAME:String_Integer(index+1)}];
    
    if (self.indexFlag != index) {
        [self animationWithIndex:index];
    }else
    {
        [[NSNotificationCenter defaultCenter]postNotificationName:TabBarRefresh object:@(index)];
    }
    
    
    //设置 "我的" 未读消息红点
    NSInteger sum = [USER_MANAGER notiPushNumberWithType:NotiType_All];
    if (sum>0) {
        [tabBar showBadgeOnItemIndex:4];
    }else {
        [tabBar hideBadgeOnItemIndex:4];
    }
}

// 动画
- (void)animationWithIndex:(NSInteger) index {
    [KSLayerAnimation animationWithTabbarIndex:index type:BounceAnimation];
    self.indexFlag = index;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
