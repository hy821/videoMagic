//
//  NetErrorOrNoDataView.h
//  CatEntertainment
//
//  Created by 闵玉辉 on 2017/11/17.
//  Copyright © 2017年 闵玉辉. All rights reserved.
//

#import <UIKit/UIKit.h>
@class NetErrorOrNoDataView;
typedef NS_ENUM(NSUInteger, CEDefaultType) {
    CENetErrorType = 0,//网络错误
    CENoDataType = 1,//无数据
    CEHiddenType = 2,//隐藏
//    CENoLoginType = 3,//没登录
};
typedef void(^ReloadBlock)(NetErrorOrNoDataView * view);
@interface NetErrorOrNoDataView : UIView
//缺省页style
@property (nonatomic,assign) CEDefaultType style;
-(instancetype)initWithVC:(UIViewController *)VC;
@property (nonatomic,copy) ReloadBlock reloadBlock;
@end
