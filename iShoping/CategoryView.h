//
//  CategoryView.h
//  iShoping
//
//  Created by SHENFENG125 on 14-4-23.
//  Copyright (c) 2014年 Cuwoyinyue. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "City.h"
@interface CategoryView : UIView<UITableViewDataSource,UITableViewDelegate,City>
@property(nonatomic,retain)UITableView *tableView;
@property(nonatomic,retain)UITableView *tableViews;
@property(nonatomic,assign)BOOL showFlag;
@property(nonatomic,retain)NSArray *mainArray;//第一层tableview
@property(nonatomic,retain)NSMutableDictionary *subCategory;//保存分区对应的下属区域键值
@property(nonatomic,retain)NSMutableArray *category;//保存城市下属所有分区
@end
