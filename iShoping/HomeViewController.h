//
//  HomeViewController.h
//  IShoping
//
//  Created by SHENFENG125 on 14-4-12.
//  Copyright (c) 2014年 Cuwoyinyue. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AutoScrollView.h"
@interface HomeViewController : UIViewController<UISearchBarDelegate,UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,retain)UIButton *cityButton;//城市选择
@property(nonatomic,retain)UISearchBar *searchBar;//搜索框
@property(nonatomic,retain)AutoScrollView *autoScrollView;
@property(nonatomic,retain)UITableView *tableView;
@end
