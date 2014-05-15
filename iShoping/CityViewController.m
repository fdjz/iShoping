//
//  CityViewController.m
//  IShoping
//
//  Created by SHENFENG125 on 14-4-15.
//  Copyright (c) 2014年 Cuwoyinyue. All rights reserved.
//

#import "CityViewController.h"
#import "ASIHTTPRequest.h"
#import "HttpRequestManager.h"
#import "ChineseToPinyin.h"
#import "GroupdetailViewController.h"
@interface CityViewController ()
{
    //显示城市
    UITableView *tableView;
    //临时保存每个分区的城市名称
    NSArray *array;
    //保存所有城市
    NSDictionary *cityDictionary;
    HttpRequestManager *requestManager;
    
  
}
//每个分区的标题
@property(nonatomic,retain)NSArray *titleSectionArray;
//用户选择的是哪个城市
@property(nonatomic,copy)NSString *selectedCity;
@end

@implementation CityViewController
-(void)dealloc
{
    [requestManager release];
    [cityDictionary release];
    [super dealloc];
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
       
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.titleSectionArray  = [NSArray arrayWithObjects:@"A",@"B",@"C",@"D",@"E",@"F",@"G",@"H",@"I",@"J",@"K",@"L",@"M",@"N",@"O",@"P",@"Q",@"R",@"S",@"T",@"U",@"V",@"W",@"X",@"Y",@"Z", nil];
    //初始化tableview
    tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 50, 320, self.view.bounds.size.height) style:UITableViewStyleGrouped];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.dataSource = self;
    tableView.delegate = self;
    [self.view addSubview:tableView];
    [tableView release];
    
    
    
    self.view.backgroundColor = [UIColor orangeColor];
    //实力化返回按钮
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [backButton setTitle:@"返回" forState:UIControlStateNormal];
    backButton.font = [UIFont systemFontOfSize:16];
    [backButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backHomeAction:) forControlEvents:UIControlEventTouchUpInside];
    [backButton setFrame:CGRectMake(5, 30, 50, 10)];
    [self.view addSubview:backButton];
    
  
   
   requestManager = [[HttpRequestManager alloc]init];
    //实力化Http对象
    [requestManager getAllsCity];
    requestManager.delegate = self;
    
    
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(130, 23, 80, 20)];
    titleLabel.font = [UIFont boldSystemFontOfSize:16];
    titleLabel.text = @"热门城市";
    [self.view addSubview:titleLabel];
    
    
    
}
//每个分区的标题
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{

   
    return self.titleSectionArray[section];
}
//分区高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
  
    return 20;
}
//设置tablefoot的高度为0.01也就是我不想要footer了
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    //千万要注意这里不能返回0，因为foot你返回0，他是有默认高度的。
    return 0.0001;
}
//右边的导航条
- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    return self.titleSectionArray;
}
//返回一个view  你可以添加给这个view添加图片，然后返回后，系统会把这个view作为每个分区头部的背景
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
//    UIImageView *imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"city_section.png"]];
//    imageView.contentMode = UIViewContentModeScaleToFill;
//    return imageView;
    UIView* myView = [[[UIView alloc] init] autorelease];
    myView.backgroundColor = [UIColor grayColor];
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 90, 22)];
    titleLabel.textColor=[UIColor whiteColor];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.text= self.titleSectionArray[section];
    [myView addSubview:titleLabel];
    [titleLabel release];
    return myView;
    
}
//选中某个城市
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //判断用户选择的城市
     //先获取是点击的这个城市的分区对应的健是多少
    NSString * key = [NSString stringWithFormat:@"key%c",indexPath.section+65];
    //找到键找到这个对应这个健的数组
    NSArray *sectionCity = [cityDictionary objectForKey:key];
    //从这个数组用indexpath.row取出当前选择的城市
    NSString *selectedCity = [sectionCity objectAtIndex:indexPath.row];
    //用NSUserDefaults进行保存值，方便传入到下一个页面
    NSUserDefaults *selectedCityDefault = [NSUserDefaults standardUserDefaults];
    [selectedCityDefault setObject:selectedCity forKey:SELECTED_CITY_KEY];
    [selectedCityDefault synchronize];
    //返回主页面
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}
//设置foot上的view
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView* myView = [[[UIView alloc] init] autorelease];
    myView.backgroundColor = [UIColor grayColor];
    return myView;
}
//表格有多少分区
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
   NSArray *cityArray = [cityDictionary allKeys];
   return cityArray.count;
}
//每个分区有多少行
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSString * key = [NSString stringWithFormat:@"key%c",section+65];
    NSArray *sectionArray = [cityDictionary objectForKey:key];
    return sectionArray.count;
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)
//每行的具体内容
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"CELL";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if(cell == nil)
    {
        cell = [[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier]autorelease];
        cell.font = [UIFont systemFontOfSize:14];
        cell.textLabel.textColor = [UIColor grayColor];
    }
    NSString * key = [NSString stringWithFormat:@"key%c",indexPath.section+65];
    NSArray *indexArray = [cityDictionary objectForKey:key];
    cell.textLabel.text = [indexArray objectAtIndex:indexPath.row];
    return cell;
}
//通过代理接收网络请求的数据
-(void)allCitys:(NSDictionary*)dictionary
{
    NSLog(@"$$$$$$$$走拉这个方法");
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    for (int i = 0; i < 26; i++) {
        NSString * key = [NSString stringWithFormat:@"key%c",i+65];
        NSMutableArray * arrayt = [[NSMutableArray alloc]init];
        [dic setObject:arrayt forKey:key];
        [arrayt release];
    }

    array = [dictionary objectForKey:@"cities"];
    for(int i = 0; i <array.count;i++)
    {
        
        //取出每个城市
        NSString *string = array[i];
        char convertString = [ChineseToPinyin sortSectionTitle:string];
        switch (convertString) {
            case 'A':
                [[dic objectForKey:@"keyA"] addObject:string];
            break;
            case 'B':
                [[dic objectForKey:@"keyB"] addObject:string];
                break;
            case 'C':
                [[dic objectForKey:@"keyC"] addObject:string];
                break;
            case 'D':
                [[dic objectForKey:@"keyD"] addObject:string];
                break;
            case 'E':
                [[dic objectForKey:@"keyE"] addObject:string];
                break;
            case 'F':
                [[dic objectForKey:@"keyF"] addObject:string];
                break;
            case 'G':
                [[dic objectForKey:@"keyG"] addObject:string];
                break;
            case 'H':
                [[dic objectForKey:@"keyH"] addObject:string];
                break;
            case 'I':
                [[dic objectForKey:@"keyI"] addObject:string];
                break;
            case 'J':
                [[dic objectForKey:@"keyJ"] addObject:string];
                break;
            case 'K':
                [[dic objectForKey:@"keyK"] addObject:string];
                break;
            case 'L':
                [[dic objectForKey:@"keyL"] addObject:string];
                break;
            case 'M':
                [[dic objectForKey:@"keyM"] addObject:string];
                break;
            case 'N':
                [[dic objectForKey:@"keyN"] addObject:string];
                break;
            case 'O':
                [[dic objectForKey:@"keyO"] addObject:string];
                break;
            case 'P':
                [[dic objectForKey:@"keyP"] addObject:string];
                break;
            case 'Q':
                [[dic objectForKey:@"keyQ"] addObject:string];
                break;
            case 'R':
                [[dic objectForKey:@"keyR"] addObject:string];
                break;
            case 'S':
                [[dic objectForKey:@"keyS"] addObject:string];
                break;
            case 'T':
                [[dic objectForKey:@"keyT"] addObject:string];
                break;
            case 'U':
                [[dic objectForKey:@"keyU"] addObject:string];
                break;
            case 'V':
                [[dic objectForKey:@"keyV"] addObject:string];
                break;
            case 'W':
                [[dic objectForKey:@"keyW"] addObject:string];
                break;
            case 'X':
                [[dic objectForKey:@"keyX"] addObject:string];
                break;
            case 'Y':
                [[dic objectForKey:@"keyY"] addObject:string];
                break;
            case 'Z':
                [[dic objectForKey:@"keyZ"] addObject:string];
                break;
                
                
         default:
                break;
        }
    }
    cityDictionary  = (NSDictionary*)[dic retain];//这里面的keyA这个键对应的是一个数组。在这个为了防止字典释放，因为这个地点是autorelease的，出了这个方法字典开辟的这块内存就会被释放，既然这块内存已经释放拉，cityDictionary这个指针即便是志向他也用拉。这块内存也不在拉
    [tableView reloadData];
    
}
//点击返回按钮
-(void)backHomeAction:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
