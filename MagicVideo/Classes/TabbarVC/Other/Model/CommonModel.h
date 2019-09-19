//
//  CommonModel.h
//  MagicVideo
//
//  Created by young He on 2019/9/18.
//  Copyright © 2019年 youngHe. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface CommonModel : NSObject

@end


@interface MineTVCellModel : NSObject
@property (nonatomic,copy) NSString *title;
@property (nonatomic,copy) NSString *imgName;
@property (nonatomic,assign) BOOL isShowRedPoint;
@end

//消息中心 及 推送消息
@interface MsgCenterCellModel : NSObject
@property (nonatomic,copy) NSString *name;
@property (nonatomic,copy) NSString *icon;
@property (nonatomic,copy) NSString *idForModel;
@property (nonatomic,copy) NSString *modifyTime;
@property (nonatomic,copy) NSString *modules;
@property (nonatomic,copy) NSString *title;
@property (nonatomic,copy) NSString *trigger;
@property (nonatomic,copy) NSString *content;
@property (nonatomic,copy) NSString *code;
@property (nonatomic,copy) NSString *createTime;
@property (nonatomic,copy) NSString *time; //By createTime
//@property (nonatomic,strong) UserBasicModel *sender;
//@property (nonatomic,strong) ExtensionModel *extension;
//@property (nonatomic,strong) AttachInfoModel *attachInfo;
//@property (nonatomic,strong) MainlyInfoModel *mainlyInfo;  //推送消息字段

//@property (nonatomic,assign) MsgCenterSubVCType vcType;
@property (nonatomic,assign) NSInteger unReadNum;

@end

NS_ASSUME_NONNULL_END
