//
//  KSTabBar.m
//  KSMovie
//
//  Created by young He on 2018/9/11.
//  Copyright © 2018年 youngHe. All rights reserved.
//

#import "KSTabBar.h"

@implementation KSTabBar

#pragma mark - Override Methods

- (void)setFrame:(CGRect)frame
{
    if (self.superview &&CGRectGetMaxY(self.superview.bounds) !=CGRectGetMaxY(frame)) {
        frame.origin.y =CGRectGetHeight(self.superview.bounds) -CGRectGetHeight(frame);
    }
    [super setFrame:frame];
}

#pragma mark - Initial Methods
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.translucent =false;
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

@end
