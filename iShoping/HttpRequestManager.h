//
//  HttpRequestManager.h
//  iShoping
//
//  Created by SHENFENG125 on 14-4-15.
//  Copyright (c) 2014年 Cuwoyinyue. All rights reserved.
//弹出框，uialertview   设置个timer  

#import <Foundation/Foundation.h>
#import "City.h"
@interface HttpRequestManager : NSObject
//创建单例对象
+(id)sharedInstance;
//这里记住，self只代表对象，不代表类，但是用到加号方法的时候，要注意self代表的是这个类。并不是这个类的对象，只有一个类的对象才能调用这个类的方法。如果self在加号方法里面，是调用不了这个类的方法的。
//使用开源库处理网络请求
-(void)parserDataByRequest:(NSString *)requestLink;
//获取所有城市列表
-(void)getAllsCity;

//获取城市分区和所选择的分类关键字
-(void)getUserPosition:(NSString*)string andUserCategory:(NSString*)string;
//获取下属城市列表
-(void)getSubCityList:(NSString *)subString andSign:(NSString*)sign;
//获得所选城市和分类(电影、酒店)
-(void)getSelectedCity:(NSString*)selectedCity andCategory:(NSString*)category andSign:(NSString*)sign andSort:(NSString*)sort andPage:(NSString*)page;
//获得所有分类
-(void)getCategory;
//实力化字典保存数据

/*如果选择关键子keyword就使用这个页面*/
//获取进入分组列表页面后，再次选择的进行网络请求
//关键字和分区都有的
-(void)getSelectedCity:(NSString*)selectedCity andCategory:(NSString*)category andSign:(NSString*)sign andSort:(NSString*)sort andPage:(NSString*)page andKeyword:(NSString*)keyword andRegion:(NSString*)region;
//关键字有，分区没有
-(void)getSelectedCity:(NSString*)selectedCity andCategory:(NSString*)category andSign:(NSString*)sign andSort:(NSString*)sort andPage:(NSString*)page andKeyword:(NSString*)keyword;
//关键字没有，分区有
-(void)getSelectedCity:(NSString*)selectedCity andCategory:(NSString*)category andSign:(NSString*)sign andSort:(NSString*)sort andPage:(NSString*)page andRegion:(NSString*)region;

@property(nonatomic,retain)NSDictionary *dictionary;
@property(nonatomic,assign)id<City>delegate;

@end
