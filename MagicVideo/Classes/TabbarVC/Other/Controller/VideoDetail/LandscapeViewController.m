//
//  LandscapeViewController.m
//  KSMovie
//
//  Created by young He on 2019/3/15.
//  Copyright © 2019年 youngHe. All rights reserved.
//

#import "LandscapeViewController.h"

@interface LandscapeViewController ()

@end

@implementation LandscapeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = Black_Color;
}

//是否允许旋屏
- (BOOL)shouldAutorotate {
    return NO;
}

//viewController中支持的所有方向
- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskLandscape;
}

//viewController初始显示时的方向
- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    return UIInterfaceOrientationLandscapeRight;
}
@end
