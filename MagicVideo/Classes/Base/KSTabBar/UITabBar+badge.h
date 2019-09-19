//
//  UITabBar+badge.h
//  KSMovie
//
//  Created by young He on 2019/6/27.
//  Copyright © 2019年 youngHe. All rights reserved.
//

NS_ASSUME_NONNULL_BEGIN

@interface UITabBar (badge)
- (void)showBadgeOnItemIndex:(int)index;
- (void)hideBadgeOnItemIndex:(int)index;
@end

NS_ASSUME_NONNULL_END
