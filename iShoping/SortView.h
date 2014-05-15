//
//  SortView.h
//  iShoping
//
//  Created by SHENFENG125 on 14-4-17.
//  Copyright (c) 2014年 Cuwoyinyue. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SortView : UIView<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,retain)UITableView *tableView;
@property(nonatomic,retain)NSArray *array;
@property(nonatomic,assign) BOOL showFlag;
@end
