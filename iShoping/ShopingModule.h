//
//  ShopingModule.h
//  iShoping
//
//  Created by SHENFENG125 on 14-4-21.
//  Copyright (c) 2014年 Cuwoyinyue. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ShopingModule : NSObject
@property (nonatomic,retain) NSArray *businesses;//团购所适用的商户列表
@property (nonatomic,retain) NSString *categories;//团购所属分类
@property (nonatomic,retain) NSString *city;//所属城市
@property (nonatomic,retain) NSString *commission_ratio;//当前团单佣金比例
@property (nonatomic,retain) NSString *current_price;//现打折后价格
@property (nonatomic,retain) NSString *deal_h5_url;// 团购HTML5页面链接，适用于移动应用和联网车载应用
@property (nonatomic,retain) NSString *deal_id;//团购单id
@property (nonatomic,retain) NSString *deal_url;//适用于网页版
@property (nonatomic,retain) NSString *description;//团购描述
@property (nonatomic,retain) NSString *distance;//距离我最近的一家团购，需要上传经纬度
@property (nonatomic,retain) NSString *image_url;// 大图片，最大图片尺寸450×280
@property (nonatomic,retain) NSString *s_image_url;//小图片 ,最大图片尺寸160×100
@property (nonatomic,retain) NSString *list_price;//原价格
@property (nonatomic,retain) NSString *publish_date;//上线时间
@property (nonatomic,retain) NSString *purchase_count;//团购当前已经购买数量
@property (nonatomic,retain) NSString *purchase_deadline;//截止购买日期
@property (nonatomic,retain) NSSet *regions;//团购适用商户所在行政区
@property (nonatomic,retain) NSString *title;//标题


//初始化
-(id)initWithShopInfos:(NSDictionary *)dictionary;

//便利构造器
+(id)ShopModuInfo:(NSDictionary*)dictionary;
@end
