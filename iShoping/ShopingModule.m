//
//  ShopingModule.m
//  iShoping
//
//  Created by SHENFENG125 on 14-4-21.
//  Copyright (c) 2014年 Cuwoyinyue. All rights reserved.
//

#import "ShopingModule.h"

@implementation ShopingModule
//初始化
-(id)initWithShopInfos:(NSDictionary *)dictionary
{
    
    
    if(self = [super init])
    {
        
        NSArray *keyArray = [dictionary allKeys];
        
        for(NSString* key in keyArray)
        {
            if([key isEqualToString:@"businesses"])
            {
                [self setValue:[dictionary objectForKey:@"businesses"] forKey:@"businesses"];
                continue;
            }
            else if([key isEqualToString:@"categories"])
            {
                [self setValue:[dictionary objectForKey:@"categories"] forKey:@"categories"];
            }
            else if([key isEqualToString:@"city"])
            {
                [self setValue:[dictionary objectForKey:@"city"] forKey:@"city"];
            }
            else if([key isEqualToString:@"commission_ratio"])
            {
                [self setValue:[dictionary objectForKey:@"commission_ratio"] forKey:@"commission_ratio"];
            }
            else if([key isEqualToString:@"current_price"])
            {
                [self setValue:[dictionary objectForKey:@"current_price"] forKey:@"current_price"];
            }
            else if([key isEqualToString:@"deal_h5_url"])
            {
                [self setValue:[dictionary objectForKey:@"deal_h5_url"] forKey:@"deal_h5_url"];
            }
            else if([key isEqualToString:@"deal_id"])
            {
                [self setValue:[dictionary objectForKey:@"deal_id"] forKey:@"deal_id"];
            }
            else if([key isEqualToString:@"deal_url"])
            {
                [self setValue:[dictionary objectForKey:@"deal_url"] forKey:@"deal_url"];
            }
            else if([key isEqualToString:@"description"])
            {
                [self setValue:[dictionary objectForKey:@"description"] forKey:@"description"];
            }
            else if([key isEqualToString:@"distance"])
            {
                [self setValue:[dictionary objectForKey:@"distance"] forKey:@"distance"];
            }
            else if([key isEqualToString:@"image_url"])
            {
                [self setValue:[dictionary objectForKey:@"image_url"] forKey:@"image_url"];
            }
            else if([key isEqualToString:@"s_image_url"])
            {
                [self setValue:[dictionary objectForKey:@"s_image_url"] forKey:@"s_image_url"];
            }
            else if([key isEqualToString:@"list_price"])
            {
                [self setValue:[dictionary objectForKey:@"list_price"] forKey:@"list_price"];
            }
            else if([key isEqualToString:@"publish_date"])
            {
                [self setValue:[dictionary objectForKey:@"publish_date"] forKey:@"publish_date"];
            }
            else if([key isEqualToString:@"purchase_count"])
            {
                [self setValue:[dictionary objectForKey:@"purchase_count"] forKey:@"purchase_count"];
            }
            else if([key isEqualToString:@"purchase_deadline"])
            {
                [self setValue:[dictionary objectForKey:@"purchase_deadline"] forKey:@"purchase_deadline"];
            }
            else if([key isEqualToString:@"regions"])
            {
                [self setValue:[dictionary objectForKey:@"regions"] forKey:@"regions"];
            }
            else if([key isEqualToString:@"title"])
            {
                [self setValue:[dictionary objectForKey:@"title"] forKey:@"title"];
            }
           
        }
    }
    return self;
}
//便利构造器
+(id)ShopModuInfo:(NSDictionary*)dictionary
{
    ShopingModule *shopModules = [[ShopingModule alloc]initWithShopInfos:dictionary];
   return [shopModules autorelease];
}
@end
