//
//  HttpRequestManager.m
//  iShoping
//
//  Created by SHENFENG125 on 14-4-15.
//  Copyright (c) 2014年 Cuwoyinyue. All rights reserved.
//

#import "HttpRequestManager.h"
#import "ASIHTTPRequest.h"

@interface HttpRequestManager ()


@end


@implementation HttpRequestManager
static const ASIHTTPRequest *requestOne;
//+(id)sharedInstance
//{
//    static HttpRequestManager *instance = nil;
//    if(instance == nil)
//    {
//        instance = [[HttpRequestManager alloc] init];
//    }
//    return instance;
//}

-(void)parserDataByRequest:(NSString *)requestLink
{
    
    
    //获取链接请求
    ASIHTTPRequest *requestOne = [[ASIHTTPRequest alloc]initWithURL:[NSURL URLWithString:requestLink]] ;
    //设置代理
    [requestOne setDelegate:self];
    //开启异步
    [requestOne startAsynchronous];
     

    //[request release];
}
- (void)requestFinished:(ASIHTTPRequest *)request
{
    //这几个页面都是alloc都是不同的对象，不同的对象，有不同的代理。
    
   //    NSString *responseString = [request responseString];
    self.dictionary = [NSDictionary dictionary];
    NSData *responseData = [request responseData];
    self.dictionary = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableContainers error:nil];
    if(_delegate &&[_delegate respondsToSelector:@selector(allCitys:)])
    {
        [_delegate allCitys:self.dictionary];
    }
    //最好让它请求完再释放
   [requestOne release];
    
   
}
- (void)requestFailed:(ASIHTTPRequest *)request
{
    NSError *error = [request error];
    
}
//获取所有城市
-(void)getAllsCity
{
    NSString *link = ALL_CITY_INFORMATION_URL;
    NSString *encodeingLink = [link stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
   [self parserDataByRequest:encodeingLink];
    
}
//搜索城市列表,有城市下属区域的和所选的关键字一块请求,positionString城市下属区域，categoryString所选分类，andEncode傻1的编码，selectedCity选中的城市
-(void)getUserPosition:(NSString*)positionString andUserCategory:(NSString*)categoryString andSelectedCity:(NSString*)selectedCity andEncode:(NSString*)encode
{
//    //获取选择的城市
    NSString *link = GROUP_SALES_SEARCHPOSITION_URL(selectedCity, positionString, categoryString, encode);
    NSString *encodeingLink = [link stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [self parserDataByRequest:encodeingLink];
    
}
//获取城市下属城市
-(void)getSubCityList:(NSString *)subString andSign:(NSString*)sign
{
    
    NSString *link = SUB_CITY_URL_LIST(subString,sign);
    NSString *encodeingLink = [link stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [self parserDataByRequest:encodeingLink];
}
/*如果不选择关键子keyword就使用这个页面*/
//获得所选城市和分类(电影、酒店),刚进入电影或者酒店的页面。
-(void)getSelectedCity:(NSString*)selectedCity andCategory:(NSString*)category andSign:(NSString*)sign andSort:(NSString*)sort andPage:(NSString*)page
{
    NSString *link = SUB_CITY_Cotegory_URL(selectedCity, sign, category, sort,page);
    NSString *encodeingLink = [link stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [self parserDataByRequest:encodeingLink];
}
//获得所有分类，以及子分类
-(void)getCategory
{
    NSString *link = CATEGORY_URL;
    NSString *encodeingLink = [link stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [self parserDataByRequest:encodeingLink];
}
/*如果选择关键子keyword就使用这个页面*/
//获取进入分组列表页面后，再次选择的进行网络请求
-(void)getSelectedCity:(NSString*)selectedCity andCategory:(NSString*)category andSign:(NSString*)sign andSort:(NSString*)sort andPage:(NSString*)page andKeyword:(NSString*)keyword andRegion:(NSString*)region
{
    NSString *link =ALL_FUNCTION_URL(selectedCity, sign, category, sort, page, keyword, region);
    NSString *encodeingLink = [link stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [self parserDataByRequest:encodeingLink];
}
//关键字有，分区没有
-(void)getSelectedCity:(NSString*)selectedCity andCategory:(NSString*)category andSign:(NSString*)sign andSort:(NSString*)sort andPage:(NSString*)page andKeyword:(NSString*)keyword
{
    NSString *link =ALL_FUNCTION_KEYWORD_URL(selectedCity, sign, category, sort, page, keyword);
    NSString *encodeingLink = [link stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [self parserDataByRequest:encodeingLink];
}
//关键没有，分区有
-(void)getSelectedCity:(NSString*)selectedCity andCategory:(NSString*)category andSign:(NSString*)sign andSort:(NSString*)sort andPage:(NSString*)page andRegion:(NSString*)region
{
    NSString *link =ALL_FUNCTION_REGION_URL(selectedCity, sign, category, sort, page, region);
    NSString *encodeingLink = [link stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [self parserDataByRequest:encodeingLink];
}
@end
