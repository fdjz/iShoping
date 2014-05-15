//
//  SortView.m
//  iShoping
//
//  Created by SHENFENG125 on 14-4-17.
//  Copyright (c) 2014年 Cuwoyinyue. All rights reserved.
//

#import "SortView.h"

@implementation SortView
#define kMenuItemHeight 40;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        CGRect rect = self.bounds;
        rect.size.width = self.bounds.size.width;
        self.tableView = [[[UITableView alloc]initWithFrame:rect style:UITableViewStylePlain]autorelease];
        self.tableView.rowHeight = kMenuItemHeight;
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        [self addSubview:self.tableView];
     self.array = @[@"默认排序",@"附近优先",@"人气最高",@"最新发布",@"价格由低到高",@"价格由高到低"];
    }
    return self;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    
   
    return self.array.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *identifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if(cell == nil)
    {
        cell = [[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier]autorelease];
        cell.backgroundColor = [UIColor whiteColor];
        cell.textLabel.textColor = [UIColor grayColor];
        cell.font = [UIFont systemFontOfSize:15];
        
    }

    cell.textLabel.text = [self.array objectAtIndex:indexPath.row];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *tempString = self.array[indexPath.row];
    @autoreleasepool {
        //参数resign
        NSDictionary *dictionary = [NSDictionary dictionaryWithObjectsAndKeys:tempString,@"sort", nil];
        [[NSNotificationCenter defaultCenter]postNotificationName:IDENTIFIERURL object:dictionary];
    }

   
    self.showFlag = YES;
    self.hidden = YES;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
