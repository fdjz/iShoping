//
//  HomeViewController.m
//  IShoping
//
//  Created by SHENFENG125 on 14-4-12.
//  Copyright (c) 2014年 Cuwoyinyue. All rights reserved.
//

#import "HomeViewController.h"
#import "LastMinuteViewController.h"
#import "HotsaleViewController.h"
#import "CityViewController.h"
#import "SearchViewController.h"
#import "GroupListViewController.h"
#import "ASIHTTPRequest.h"
@implementation UIView (allView)

- (void)allViews:(NSInteger)indent
{
    NSLog(@"[%2d] : %@", indent++, self);
    for (UIView *aView in self.subviews) {
        [aView allViews:indent];
    }
}

@end
@interface HomeViewController ()
{
    //声明pageControl指示点
    UIPageControl *_pageControl;
    //保存scorllView的图片数组
    NSArray *_imageNames;
    //定时器，scrollView
    NSTimer *_timer;
    //定义scorllView当前页数。
    int _currentPage;
    //
}
-(void)_cityNavigationBarItem;
-(void)_searchBarItem;
@property(nonatomic,retain)UIButton *movieButton;//电影
@property(nonatomic,retain)UIButton *hotelButton;//酒店
@end

@implementation HomeViewController
-(void)dealloc
{
    RELEASE_SAFETY(_hotelButton);
    RELEASE_SAFETY(_movieButton);
    RELEASE_SAFETY(_searchBar);
    RELEASE_SAFETY(_cityButton);
    //停止timer
    [_timer invalidate];
    [super dealloc];
}
-(void)viewWillAppear:(BOOL)animated
{
    self.tabBarController.tabBar.hidden = NO;
   //如果第一次进入，那么SELECTED_CITY_KEY为空，就不能走这个方法。
    if([[NSUserDefaults standardUserDefaults]objectForKey:SELECTED_CITY_KEY] != nil)
    {
        NSUserDefaults *selectedCity = [NSUserDefaults standardUserDefaults];
        NSString *city = [selectedCity objectForKey:SELECTED_CITY_KEY];
        [self.cityButton setTitle:city forState:UIControlStateNormal];
    }
    
    
}
- (void)allView:(UIView *)rootView indent:(NSInteger)indent
{
    NSLog(@"[%2d] : %@", indent++, rootView);
    for (UIView *aView in rootView.subviews) {
        [self allView:aView indent:indent];
    }
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        //为tabBar添加图标
        UITabBarItem *moreTabBar = [[UITabBarItem alloc]initWithTitle:@"首页" image:[UIImage imageNamed:@"TabHome.png"] selectedImage:[UIImage imageNamed:@"TabHome.png"]];
        self.tabBarItem = moreTabBar;
        //接收数组的值。
     
    }
    return self;
}
-(void)loadView
{
    [super loadView];
    NSArray *array = @[@"1.jpg", @"2.jpg", @"3.jpg"];
    CGRect rect = CGRectMake(0, 0, self.view.bounds.size.width, (self.view.bounds.size.height)/3.8);
    AutoScrollView *autoView = [AutoScrollView autoScrollViewWithFrame:rect imageNames:array];
    [self.view addSubview:autoView];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    //设置这个属性，坐标是从0开始，防止scrollView图片总是上下滚动。相当于原来的坐标原点（0，0）是在屏幕左上角，现在加了这个属性，那么（0，0）是在导航条的左下角。
    //下面这个属性是非常至关重要的＊＊＊＊＊＊＊＊＊＊
    self.edgesForExtendedLayout = UIRectEdgeNone;//加了这个它就不会取调用contentInset那个私有方法拉。那个它的坐标原点就是从00开始貌似。
    self.title = @"主页";
	// Do any additional setup after loading the view.
    //初始化导航条城市选择按钮
    [self _cityNavigationBarItem];
//    //初始化导航条searchBar
   //[self _searchBarItem];

//    //初始化分割线
   [self _spearaterView:CGRectMake(0,self.view.bounds.size.height/3+self.view.bounds.size.height/3-64 , 320, 1)];
//    //初始化工具模块
    [self _toolButtonCategory];
//初始化tableView
    [self tableview];
    //初始化搜所
    
    //初始化view放在导航条上面
    
    
    UIButton *searchButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [searchButton setTitle:@"搜索" forState:UIControlStateNormal];
    searchButton.font = [UIFont systemFontOfSize:16];
    [searchButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [searchButton addTarget:self action:@selector(serachAction:) forControlEvents:UIControlEventTouchUpInside];
    [searchButton setBackgroundColor:[UIColor clearColor]];
    [searchButton setFrame:CGRectMake(0, 0, 50, 10)];
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc]initWithCustomView:searchButton];
    self.navigationItem.rightBarButtonItem = rightButton;
    RELEASE_SAFETY(rightButton);
   }
//初始化tableview
-(void)tableview
{
    self.tableView = [[[UITableView alloc]initWithFrame:CGRectMake(0, self.view.bounds.size.height/3.5+self.view.bounds.size.height/2.5-64,self.view.bounds.size.width, self.view.bounds.size.height - 280) style:UITableViewStylePlain] autorelease];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.view addSubview:self.tableView];

}
//初始化分类
-(void)_toolButtonCategory
{
    self.movieButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [self.movieButton setFrame:CGRectMake(80, self.view.bounds.size.height/16+self.view.bounds.size.height/2.5-64, 45, 45)];
    //点击进入团购列表页面
    [self.movieButton addTarget:self action:@selector(groupListAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.movieButton setBackgroundImage:[UIImage imageNamed:@"searchCategory_selected33@2x"] forState:UIControlStateNormal];
    [self.view addSubview:self.movieButton];
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(90, self.view.bounds.size.height/6+self.view.bounds.size.height/2.5-64, 45, 15)];
    label.text = @"电影";
    label.font = [UIFont systemFontOfSize:12];
    label.textColor = [UIColor grayColor];
    [self.view addSubview:label];
    RELEASE_SAFETY(label);
    
    self.hotelButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [self.hotelButton  setFrame:CGRectMake(195, self.view.bounds.size.height/16+self.view.bounds.size.height/2.5-64, 45, 45)];
    //点击进入团购列表页面
#warning 为了团购列表好区分，给button的tag也传递过去
    [self.hotelButton  addTarget:self action:@selector(groupListAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.hotelButton  setBackgroundImage:[UIImage imageNamed:@"searchCategory_selected42"] forState:UIControlStateNormal];
    [self.view addSubview:self.hotelButton];
    
    UILabel *label1 = [[UILabel alloc]initWithFrame:CGRectMake(205, self.view.bounds.size.height/6+self.view.bounds.size.height/2.5-64, 45, 15)];
    label1.text = @"酒店";
    label1.font = [UIFont systemFontOfSize:12];
    label1.textColor = [UIColor grayColor];
    [self.view addSubview:label1];
    RELEASE_SAFETY(label1);
    
    

}
-(void)_spearaterView:(CGRect)sender
{
    UIView *view = [[UIView alloc]initWithFrame:sender];
    [view setBackgroundColor:[UIColor grayColor]];
    [self.view addSubview:view];
    [view release];
}
#pragma mark - 初始化导航条searchBar
-(void)_searchBarItem
{
    //初始化searchBar
    self.searchBar = [[[UISearchBar alloc]initWithFrame:CGRectMake(100, 20, 228, 0)]autorelease];
    self.searchBar.delegate = self;
    UIBarButtonItem *searchBarItem = [[UIBarButtonItem alloc]initWithCustomView:self.searchBar];
    self.navigationItem.rightBarButtonItem = searchBarItem;
    RELEASE_SAFETY(searchBarItem);
    //给self.view添加点击手势，方便取消searchBar的第一响应者
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handleAction:)];
    [self.view addGestureRecognizer:tap];
    [tap release];
}
#pragma mark - 初始化导航条城市选择按钮 -
-(void)_cityNavigationBarItem
{
    //初始化view放在导航条上面
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 70, 10)];
    view.backgroundColor = [UIColor clearColor];
    
    self.cityButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [self.cityButton setTitle:@"北京" forState:UIControlStateNormal];
    self.cityButton.font = [UIFont systemFontOfSize:16];
    [self.cityButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.cityButton addTarget:self action:@selector(cityButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.cityButton setBackgroundColor:[UIColor clearColor]];
    [self.cityButton setFrame:CGRectMake(0, 0, 50, 10)];
    [view addSubview:self.cityButton];
    
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc]initWithCustomView:view];
    self.navigationItem.leftBarButtonItem = leftButton;
    RELEASE_SAFETY(view);
    RELEASE_SAFETY(leftButton);
}
#pragma mark -取消searchBar的键盘
-(void)handleAction:(id)sender
{
    [self.searchBar resignFirstResponder];
}
#pragma mark －初始化scrollview的图片数组

#pragma mark tabView数据源方法

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    

    static NSString *reuserIdentifier = @"CELL_ID";
    //从重用队列中根据单元格的重用标示符获取可以别重用的单元格.
    //dequeueReusableCellWithIdentifier是出栈
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuserIdentifier];
    //判断如果重用队列中目前没有可用的重用单元格,则创建一个新的单元格对象,并且为其指定重用标示符
    if (cell ==  nil) {
        cell = [[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle
                                      reuseIdentifier:reuserIdentifier]autorelease];//这个属性是带子标题,在下面设置了.

        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    cell.textLabel.font = [UIFont systemFontOfSize:14];
    cell.textLabel.textColor = [UIColor grayColor];

    if(indexPath.row == 0)
    {
    cell.textLabel.text = @"限时抢购";
        
    }
    else if(indexPath.row == 1)
    {
        cell.textLabel.text = @"热销排行";
    }
    return cell;
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
   
    switch (indexPath.row) {
        case 0:
        {
            LastMinuteViewController *lastViewController = [[LastMinuteViewController alloc]init];
            [self.navigationController pushViewController:lastViewController animated:YES];
            RELEASE_SAFETY(lastViewController);
        }
        break;
        case 1:
        {
            HotsaleViewController *hotViewController = [[HotsaleViewController alloc]init];
            [self.navigationController pushViewController:hotViewController animated:YES];
            RELEASE_SAFETY(hotViewController);
        }
        default:
            break;
    }
}
//城市列表
-(void)cityButtonAction:(id)sender
{
    CityViewController *city = [[CityViewController alloc]init];
    [self presentViewController:city animated:YES completion:nil];
    RELEASE_SAFETY(city);
}
//搜索列表
-(void)serachAction:(id)sender
{
    SearchViewController *search = [[SearchViewController alloc]init];
    [self presentViewController:search animated:YES completion:nil];
    RELEASE_SAFETY(search);
}
//点击电影或者酒店进入团购列表
-(void)groupListAction:(UIButton*)sender
{
    NSString *tempString;
    if([sender isEqual: self.movieButton] == YES)
    {
       tempString = @"电影";
    }
    else
    {
       tempString = @"酒店";
    }
    self.tabBarController.tabBar.hidden = YES;
    GroupListViewController *grop = [[GroupListViewController alloc]init];
    
    [self.navigationController pushViewController:grop animated:YES];
    grop.selected = tempString;
    grop.result = @"first";
    RELEASE_SAFETY(grop);
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
