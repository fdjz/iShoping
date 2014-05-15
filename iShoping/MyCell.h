//
//  MyCell.h
//  iShoping
//
//  Created by SHENFENG125 on 14-4-17.
//  Copyright (c) 2014年 Cuwoyinyue. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyCell : UITableViewCell
@property(nonatomic,retain)UIImageView *headImageView;//图像
@property(nonatomic,retain)UILabel *titleLabel;//主标题，具体哪家
@property(nonatomic,retain)UILabel *saleLabel;//售价
@property(nonatomic,retain)UILabel *personLabel;//评论人数
@property(nonatomic,retain)UILabel *addressLabel;//地址
@property(nonatomic,retain)UILabel *discountLabel;//原价
@end
