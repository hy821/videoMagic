//
//  NSObject+BaseObject.m
//  SmallStuff
//
//  Created by Hy on 2017/3/29.
//  Copyright © 2017年 yuhuimin. All rights reserved.
//

#import "NSObject+BaseObject.h"

@implementation NSObject (BaseObject)
- (CGFloat (^)(CGFloat))sizeW
{
    return ^(CGFloat size){
        size = size * (ScreenWidth / 375);
        return size;
    };
}

- (CGFloat (^)(CGFloat))sizeH
{
    return ^(CGFloat size){
        size = size * (ScreenHeight / 667);
        return size;
    };
}
-(CGFloat)contentOffset
{
    //[UIApplication sharedApplication].statusBarFrame.size.height == 44?88.f:64.f
    return [UIApplication sharedApplication].statusBarFrame.size.height == 44?88.f:64.f;
}
-(CGFloat)tabbarHeight
{
    return [Helper isIphoneX]?83:49;
}

-(CGFloat)statusBarHeight
{
    return [UIApplication sharedApplication].statusBarFrame.size.height;
}


@end
