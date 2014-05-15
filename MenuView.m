//
//  MenuView.m
//  iShoping
//
//  Created by SHENFENG125 on 14-4-16.
//  Copyright (c) 2014年 Cuwoyinyue. All rights reserved.
//

#import "MenuView.h"
#import "NSString+ShaOnePass.h"
#import "HttpRequestManager.h"
#define kMenuItemHeight 28;
@interface MenuView()
{
    NSString *selectedCityString;//保存用户选择的城市
    HttpRequestManager *requestManager;
    NSString *subCity;
    
    
}
@property(nonatomic,retain)NSString *secondString;
@property(nonatomic,retain)NSArray *secondArray;


@end
@implementation MenuView
-(void)dealloc
{
    [_zoneArray release];
    [_cityWayDictionary release];
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
        self.cityWayDictionary = [NSMutableDictionary dictionary];
        self.zoneArray = [NSMutableArray array];
        self.backgroundColor = [UIColor greenColor];
        CGRect rect = self.bounds;
        rect.size.width = self.bounds.size.width/2;
        self.tableView = [[[UITableView alloc]initWithFrame:rect style:UITableViewStylePlain]autorelease];
        self.tableView.rowHeight = kMenuItemHeight;
        self.tableView.delegate = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.tableView.dataSource = self;
        [self addSubview:self.tableView];
        
        //获取到用户所选择的城市
        NSUserDefaults *selectedCity = [NSUserDefaults standardUserDefaults];
#warning 这个变量需要变
        //选择的电影或者酒店,获得所选城市
        //选择的城市,你选择的时候，还会变
       selectedCityString  = [selectedCity objectForKey:SELECTED_CITY_KEY];
        //把选择过的城市传递给sign,然后得到sign
       NSString *sign = [self getSignCity:selectedCityString];

        
        //通过代理接收值，这几个页面都是alloc都是不同的对象，不同的对象，有不同的代理。
        requestManager = [[HttpRequestManager  alloc]init];
        //进行网络请求
        //url请求
        [requestManager getSubCityList:selectedCityString andSign:sign];
        //设定本类对象为http的代理,这里给所有城市那个代理就替换拉
        requestManager.delegate = self;
    
        
      //实力化tableViews
        CGRect rects = self.bounds;
        rects.size.width = self.bounds.size.width/2;
        rects.origin.x = self.bounds.size.width/2;
        self.tableViews = [[[UITableView alloc]initWithFrame:rects style:UITableViewStyleGrouped]autorelease];
        self.tableViews.rowHeight = kMenuItemHeight;
        self.tableViews.delegate = self;
        self.tableViews.backgroundColor = [UIColor whiteColor];
         _tableViews.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.tableViews.dataSource = self;
        [self addSubview:self.tableViews];
        
        
       
    }
    return self;
}
//判断是否显示view的方法
//sign生成器
-(NSString *)getSignCity:(NSString*)city
{
    NSString *appkey = @"13009273";
    NSString *appsecret = @"c376813f9b3b482cb3c2b51a08d23406";
    NSString *string = @"city";
    NSString *stringc = [string stringByAppendingString:city];
    NSString *readCity = [[appkey stringByAppendingString:stringc]stringByAppendingString:appsecret];
    //sign生成器
    NSString *cString = [readCity sha1:readCity];
    NSString *sString = [cString uppercaseString];
    //返回傻1生成的字符串
    return [[sString retain]autorelease];
}
//网络请求
-(void)allCitys:(NSDictionary*)dictionary
{
    NSArray *array = [dictionary objectForKey:@"cities"];
    NSDictionary *doy = [array objectAtIndex:0];
    //循环这个数组，取出每个数组元素
    NSArray *arrayCity = [doy objectForKey:@"districts"];
    for(int i = 0;i < arrayCity.count;i++)
    {
    NSDictionary *doyCity = [arrayCity objectAtIndex:i];
    //取出数组第一个元素的district_name是朝阳区
    NSString *city = [doyCity objectForKey:@"district_name"];
    [_zoneArray addObject:city];
    //取出城市分区对应的具体路
    NSArray *cityWay = [doyCity objectForKey:@"neighborhoods"];
    [self.cityWayDictionary setObject:cityWay forKey:city];
    }
    
    [_tableView reloadData];
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    if(tableView == self.tableViews)
    {
        
        return self.secondArray.count;
        
       
    }
    return self.zoneArray.count;
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
            self.secondString = [self.zoneArray objectAtIndex:indexPath.row];
            //得到选中文字的下一级
           self.secondArray = [self.cityWayDictionary objectForKey:self.secondString];
            
            }
      
        if(tableView == self.tableView && self.secondArray.count != 0)//或者遍历
        {
        
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
        }
        
    }
    NSArray *tempArray = (self.tableViews == tableView)?self.secondArray:self.zoneArray;
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
      subCity = [self.zoneArray objectAtIndex:indexPath.row];
      
        //得到选中的文字
        self.secondString = [self.zoneArray objectAtIndex:indexPath.row];
        //得到选中文字的下一级
       
            self.secondArray = [self.cityWayDictionary objectForKey:self.secondString];
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
        subCity = [self.zoneArray objectAtIndex:indexPath.row];
       
        self.showFlag = YES;
        self.hidden = YES;
        //传进城市和分区  分区下面的用关键字吧！
        @autoreleasepool {
            //参数resign
            NSLog(@"-------------%@",subCity);
            NSDictionary *dictionary = [NSDictionary dictionaryWithObjectsAndKeys:[@"region"stringByAppendingString: subCity],@"region", nil];
            [[NSNotificationCenter defaultCenter]postNotificationName:IDENTIFIERURL object:dictionary];
        }
       
    return;  //在这里返回最终的选择
    }
    
    //获取分区的下属列表
    if(tableView == self.tableViews)
    {
        //点击的时候它就跑到第二个tableview的indexpath了
    
    NSString *subSection = [self.secondArray objectAtIndex:indexPath.row];
    self.showFlag = YES;
    self.hidden = YES;
        @autoreleasepool {
            //参数resign
            NSArray *array = [NSArray arrayWithObjects:[@"region"stringByAppendingString:subCity],[@"keyword" stringByAppendingString:subSection ], nil];
           NSDictionary *dictionary = [NSDictionary dictionaryWithObjectsAndKeys:array,@"subRegion", nil];
            [[NSNotificationCenter defaultCenter]postNotificationName:IDENTIFIERURL object:dictionary];
        }
        
        return;//确实管事这个自动释放池
        

    }
    //tableview的
    
       
    
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
//    CGRect rect = self.bounds;
//    rect.size.height = kMenuItemHeight1;
//    NSLog(@"%@",NSStringFromCGRect(rect));
//    self.button1.frame = rect;
//    rect.origin.y += kMenuItemHeight2;
//    NSLog(@"%@",NSStringFromCGRect(rect));
//    self.button2.frame = rect;
    
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
