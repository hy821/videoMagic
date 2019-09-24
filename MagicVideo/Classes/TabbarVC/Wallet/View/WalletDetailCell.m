//
//  WalletDetailCell.m
//  MagicVideo
//
//  Created by young He on 2019/9/24.
//  Copyright © 2019年 youngHe. All rights reserved.
//

#import "WalletDetailCell.h"

@implementation WalletDetailCell

+(instancetype)cellForTableView:(UITableView *)tableView {
    static NSString * ID = @"WalletDetailCell_ID";
    WalletDetailCell * cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if(cell == nil) {
        cell = [[WalletDetailCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }return cell;
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self createUI];
    }return self;
}

-(void)createUI {
    self.backgroundColor = LightGray_Color;

}

@end
