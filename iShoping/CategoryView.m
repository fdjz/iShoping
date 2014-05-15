//
//  CategoryView.m
//  iShoping
//
//  Created by SHENFENG125 on 14-4-23.
//  Copyright (c) 2014年 Cuwoyinyue. All rights reserved.
//

#import "CategoryView.h"
#import "NSString+ShaOnePass.h"
#import "HttpRequestManager.h"
#define kMenuItemHeight 28;
@interface CategoryView()
{
    
    HttpRequestManager *requestManager;
    NSString *category;
    
}
@property(nonatomic,retain)NSString *secondString;
@property(nonatomic,retain)NSArray *secondArray;
@end

@implementation CategoryView
-(void)dealloc
{
    
    [_subCategory release];
    [_category release];
    [requestManager release];
    [_tableViews release];
    [_tableView release];
    [super dealloc];
}
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.subCategory = [NSMutableDictionary dictionary];
        self.category = [NSMutableArray array];
        self.backgroundColor = [UIColor greenColor];
        CGRect rect = self.bounds;
        rect.size.width = self.bounds.size.width/2;
        self.tableView = [[UITableView alloc]initWithFrame:rect style:UITableViewStylePlain];
        self.tableView.rowHeight = kMenuItemHeight;
        self.tableView.delegate = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.tableView.dataSource = self;
        [self addSubview:self.tableView];
        RELEASE_SAFETY(_tableView);
        

        
        
        //通过代理接收值，这几个页面都是alloc都是不同的对象，不同的对象，有不同的代理。
        requestManager = [[HttpRequestManager  alloc]init];
        //进行网络请求
        //url请求
        [requestManager getCategory];
        //设定本类对象为http的代理,这里给所有城市那个代理就替换拉
        requestManager.delegate = self;
        
        
        //实力化tableViews
        CGRect rects = self.bounds;
        rects.size.width = self.bounds.size.width/2;
        rects.origin.x = self.bounds.size.width/2;
        self.tableViews = [[UITableView alloc]initWithFrame:rects style:UITableViewStyleGrouped];
        self.tableViews.rowHeight = kMenuItemHeight;
        self.tableViews.delegate = self;
        self.tableViews.backgroundColor = [UIColor whiteColor];
        _tableViews.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.tableViews.dataSource = self;
        [self addSubview:self.tableViews];
        [_tableViews release];
        
        
    }
    return self;
}
//判断是否显示view的方法
//网络请求
-(void)allCitys:(NSDictionary*)dictionary
{
    
    NSArray *array = [dictionary objectForKey:@"categories"];
    for(int i = 0; i < array.count; i++)
    {
        NSDictionary *categoryDictionary = [array objectAtIndex:i];
        NSString *categoryString = [categoryDictionary objectForKey:@"category_name"];
        //将大分类保存到数组self.category
        [self.category addObject:categoryString];
        NSArray *subctyArray = [categoryDictionary objectForKey:@"subcategories"];
        //将小分类self.subCategory保存到字典
        [self.subCategory setObject:subctyArray forKey:categoryString];
    }
    [_tableView reloadData];
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    if(tableView == self.tableViews)
    {
        
        return self.secondArray.count;
        
        
    }
    return self.category.count;
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

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
        //&& indexPath.row !=2*/
        if(tableView == self.tableView)
        {
            
            //得到选中的文字
            self.secondString = [self.category objectAtIndex:indexPath.row];
            //得到选中文字的下一级
            self.secondArray = [self.subCategory objectForKey:self.secondString];
            
        }
        
        if(tableView == self.tableView && self.secondArray.count != 0)//或者遍历
        {
            
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            
        }
        
    }
    NSArray *tempArray = (self.tableViews == tableView)?self.secondArray:self.category;
    cell.textLabel.text = [tempArray objectAtIndex:indexPath.row];
    if(tableView == self.tableViews)
    {
        
    }
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    if(tableView == self.tableView)
    {
        category=[self.category objectAtIndex:indexPath.row];
        //得到选中的文字
        self.secondString = [self.category objectAtIndex:indexPath.row];
        //得到选中文字的下一级
        
        self.secondArray = [self.subCategory objectForKey:self.secondString];
        _tableViews.separatorStyle =UITableViewCellSeparatorStyleSingleLine;
        
        [self.tableViews reloadData];
        
    }
    if(self.secondArray.count == 0)
    {
        _tableViews.separatorStyle =UITableViewCellSeparatorStyleNone;
    }
    //得到用户最终选择的数据,分区的
    if(self.secondArray.count == 0)
    {
        NSString *categorye = [self.category objectAtIndex:indexPath.row];
        NSLog(@"----%@",categorye);
        self.showFlag = YES;
        self.hidden = YES;
        @autoreleasepool {
            //参数resign
            NSDictionary *dictionary = [NSDictionary dictionaryWithObjectsAndKeys:category,@"category", nil];
            [[NSNotificationCenter defaultCenter]postNotificationName:IDENTIFIERURL object:dictionary];
        }
        return;  //在这里返回最终的选择
    }
    
    //获取分区的下属列表
    if(tableView == self.tableViews)
    {
        
        NSString *subCategory = [self.secondArray objectAtIndex:indexPath.row];
        self.showFlag = YES;
        self.hidden = YES;
        @autoreleasepool {
             NSArray *array = [NSArray arrayWithObjects:category,[@","stringByAppendingString:subCategory], nil];
            //参数resign
            NSDictionary *dictionary = [NSDictionary dictionaryWithObjectsAndKeys: array,@"subCategory", nil];
            [[NSNotificationCenter defaultCenter]postNotificationName:IDENTIFIERURL object:dictionary];
        }
        return;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if(tableView == self.tableViews)
    {
        
        return 0.0001;
    }
    return 0.0001;
}
//设置tablefoot的高度为0.01也就是我不想要footer了
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    //千万要注意这里不能返回0，因为foot你返回0，他是有默认高度的。
    if(tableView == self.tableViews)
    {
        
        return 0.0001;
    }
    return 0.0001;
}
- (void)layoutSubviews{   
    [super layoutSubviews];

}
@end
