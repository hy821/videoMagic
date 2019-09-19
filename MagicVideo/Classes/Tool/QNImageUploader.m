//
//  QNImageUploader.m
//  KSMovie
//
//  Created by young He on 2018/10/18.
//  Copyright © 2018年 youngHe. All rights reserved.
//

#import "QNImageUploader.h"
#import <QiniuSDK.h>

@implementation QNImageUploader

//+ (void)uploadImageWithModel:(UploadMsgModel*)model complete:(void(^)(NSString *name, UploadImageState state))complete
//{
//    QNUploadManager *upManager = [[QNUploadManager alloc] init];
//    NSData *data = UIImageJPEGRepresentation(model.uploadImg, 0.8);
//    [upManager putData:data key:model.relative token:model.token complete: ^(QNResponseInfo *info, NSString *key, NSDictionary *resp) {
//        
//        SSLog(@"%@", info);
//        SSLog(@"%@", resp);
//        if (info.statusCode == 200) {
//            if (complete) {
//                complete(@"" ,UploadImageSuccess);
//            }
//        }else {
//            if (complete) {
//                complete(@"" ,UploadImageFailed);
//            }
//        }
//      
//    } option:nil];
//    
//}

@end
