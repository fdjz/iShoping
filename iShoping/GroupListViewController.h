//
//  GroupListViewController.h
//  IShoping
//
//  Created by SHENFENG125 on 14-4-15.
//  Copyright (c) 2014年 Cuwoyinyue. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "City.h"
#import <CoreText/CoreText.h>

@interface GroupListViewController : UIViewController<City,UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,retain)NSString *selected;//接收用户选择的是电影还是酒店
@property(nonatomic,copy)NSString *signString;
@property(nonatomic,retain)NSMutableArray *dataMutableArray;//接收请求下来的数据
@property(nonatomic,retain)NSString *result;//判断是哪个页面回去的viewwillappear
@end
