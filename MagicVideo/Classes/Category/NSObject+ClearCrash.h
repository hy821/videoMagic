//
//  NSObject+ClearCrash.h
//  NewTarget
//
//  Created by Mr.差不多 on 16/7/15.
//  Copyright © 2016年  rw. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (ClearCrash)
/** 计算缓存 */
+ (void)getFileCacheSizeWithPath:(NSString *)path completion:(void(^)(NSInteger total))completion;
/** 清空缓存 */
+ (void)removeCacheWithCompletion:(void (^)(void))completion;
/** 清除指定路径的缓存  */
+ (void)removeCacheWithPath:(NSString*)path AndCompletion:(void (^)(void))completion;
/** 清空视频缓存 */
+ (void)removeCacheWithCompletion:(void (^)(void))completion withFileType:(NSString*)type;

/** 清空除了视频的缓存 */
+ (void)removeCacheExceptVideoWithCompletion:(void (^)(void))completion;
/** 计算除了视频的缓存 */
+ (void)getFileCacheSizeExceptVideoWithPath:(NSString *)path completion:(void(^)(NSInteger total))completion;


@end
