//
//  QNImageUploader.h
//  KSMovie
//
//  Created by young He on 2018/10/18.
//  Copyright © 2018年 youngHe. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, UploadImageState) {
    UploadImageFailed   = 0,
    UploadImageSuccess  = 1
};

@interface QNImageUploader : NSObject

//+ (void)uploadImageWithModel:(UploadMsgModel*)model complete:(void(^)(NSString *name, UploadImageState state))complete;

@end
