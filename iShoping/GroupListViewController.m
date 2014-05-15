//
//  GroupListViewController.m
//  IShoping
//
//  Created by SHENFENG125 on 14-4-15.
//  Copyright (c) 2014年 Cuwoyinyue. All rights reserved.
//

#import "GroupListViewController.h"
#import "MenuView.h"
#import "SortView.h"
#import "CategoryView.h"
#import "MyCell.h"
#import "ASIHTTPRequest.h"
#import "HttpRequestManager.h"
#import "NSString+ShaOnePass.h"
#import "ShopingModule.h"
#import "UIImageView+WebCache.h"
#import "MJRefresh.h"
#import "GroupdetailViewController.h"
@interface GroupListViewController ()
{
    MJRefreshHeaderView *_header;
    MJRefreshFooterView *_footer;
     HttpRequestManager *requestManager;
    MenuView *_menu;//自定义cell，城市商区
    SortView *_sort;//自定义cell，排序方式
    CategoryView *_category;//自定义cell，所有分类
    UITableView *_tableView;//显示数据
    
    
    NSString *city;//城市
    NSString *region;//分区
    NSString *keyword;//子分区
    NSString *keywordOne;//子分类
    NSString *category;//分类
    NSString *sign;//sign
    NSString *sort;
    int page;
}
@property(nonatomic,retain)NSMutableArray *mainArray;//保存数据
@property(nonatomic,copy)NSString *selectedCityString;//接收用户选择哪个城市


@end

@implementation GroupListViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"团购列表";
        sort =@"1";
        region =@"";//分区
        keyword=@"";//子分区
        keywordOne=@"";//子分类
        page=0;
    }
    return self;
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //刚进入的时候
    if([_result isEqualToString: @"first"] == YES)
    {
    [self getEnter];
    }
    
    
    
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor greenColor];
    self.dataMutableArray = [NSMutableArray array];
    //初始化接受数据的数组
	// Do any additional setup after loading the view.
    //键盘高度216（英文）  中文键盘（252）
    //初始化page
   
    //字符串用copy
    //定义头部标题区
    double height = self.view.bounds.size.height/5.0;//这块最终一定要改为18.
    UIView *headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, height)];
    headView.backgroundColor = [UIColor orangeColor];
    UIButton *categoryButton = [UIButton buttonWithType:UIButtonTypeCustom];
    categoryButton.frame = CGRectMake(0, 0, headView.bounds.size.width/3-1, headView.bounds.size.height);
    [categoryButton setTitle:@"所有分类" forState:UIControlStateNormal];
    [categoryButton addTarget:self action:@selector(categoryAction:) forControlEvents:UIControlEventTouchUpInside];
    categoryButton.tag = 1120;
    [categoryButton setBackgroundColor:[UIColor grayColor]];
    [headView addSubview:categoryButton];
    
    
    UIButton *cityCategory = [UIButton buttonWithType:UIButtonTypeCustom];
    cityCategory.frame = CGRectMake(107, 0, headView.bounds.size.width/3-1, headView.bounds.size.height);
    [cityCategory setTitle:@"城市商区" forState:UIControlStateNormal];
     [cityCategory addTarget:self action:@selector(cityAction:) forControlEvents:UIControlEventTouchUpInside];
    cityCategory.tag = 1121;
    [cityCategory setBackgroundColor:[UIColor grayColor]];
    [headView addSubview:cityCategory];
    
    UIButton *sortCategory = [UIButton buttonWithType:UIButtonTypeCustom];
    sortCategory.frame = CGRectMake(214, 0, headView.bounds.size.width/3, headView.bounds.size.height);
    [sortCategory setTitle:@"排序方式" forState:UIControlStateNormal];
    sortCategory.tag = 1122;
    [sortCategory addTarget:self action:@selector(sortAction:) forControlEvents:UIControlEventTouchUpInside];
    [sortCategory setBackgroundColor:[UIColor grayColor]];
    [headView addSubview:sortCategory];
    
    [self.view addSubview:headView];
    
    
    
    
    CGRect rect = self.view.bounds;
    rect.origin.y = height;
   if([UIScreen mainScreen].bounds.size.height == 568.000000)
   {
    rect.size.height = 472;
   }
    else
    {
        rect.size.height = 389.5;
    }
    //_tableView的高度起点是96，64+32。并不是32.是96，上面的导航条还是占空间的
    _tableView = [[UITableView alloc]initWithFrame:rect style:UITableViewStylePlain];
    _tableView.rowHeight = 70;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    //给屏幕下方的东西添加单机手势，一点上面button弹下来的view东西就消失。这种方法只能单机button的时候，给上面铺上一层view。给view添加单机手势。
//    UITapGestureRecognizer *tapGestTabeleView = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(cancelButton:)];
//     [self.view addGestureRecognizer:tapGestTabeleView];
//    [tapGestTabeleView release];
    
    RELEASE_SAFETY(_tableView);
    
    
#warning 测试数据
    //实力化menuview
    _menu = [[MenuView alloc]initWithFrame:CGRectMake(0,  height, headView.bounds.size.width,self.view.bounds.size.height- self.view.bounds.size.height/2)];
    _menu.backgroundColor = [UIColor orangeColor];
    _menu.showFlag = YES;
    if(_menu.showFlag == YES)
    {
        _menu.hidden = YES;
    }
    [self.view addSubview:_menu];
    RELEASE_SAFETY(_menu);
 
    //实力化SortView
    _sort = [[SortView alloc]initWithFrame:CGRectMake(0,  height, headView.bounds.size.width,self.view.bounds.size.height- self.view.bounds.size.height/2)];
    _sort.backgroundColor = [UIColor orangeColor];
    _sort.showFlag = YES;
    if(_sort.showFlag == YES)
    {
        _sort.hidden = YES;
    }
    [self.view addSubview:_sort];
    RELEASE_SAFETY(_sort);
    //实力化category
    _category = [[CategoryView alloc]initWithFrame:CGRectMake(0,  height, headView.bounds.size.width,self.view.bounds.size.height- self.view.bounds.size.height/2)];
    _category.backgroundColor = [UIColor orangeColor];
    _category.showFlag = YES;
    if(_category.showFlag == YES)
    {
        _category.hidden = YES;
    }
    [self.view addSubview:_category];
    RELEASE_SAFETY(_category);
    
    
    // 3.集成刷新控件
    // 3.1.下拉刷新
   [self addHeader];
    
//    // 3.2.上拉加载更多
    [self addFooter];
   
    
    category = self.selected;
    //注册通知，用来接收其他页面的传过来的值
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(requestGetUrl:) name:IDENTIFIERURL object:nil];
    
    //通过代理接收值
    requestManager = [[HttpRequestManager alloc]init];//通过代理接收值
    requestManager.delegate = self;
}
//重写手势方法
//让button上的view失去焦点，消失
-(void)cancelButton:(id)sender
{
    if(_menu.showFlag == NO || _category.showFlag == NO || _sort.showFlag == NO)
    {
    
    if(_menu.showFlag == NO)
    {
        _menu.hidden = YES;
        _menu.showFlag = YES;
    }
    if(_sort.showFlag == NO)
    {
        _sort.hidden = YES;
        _sort.showFlag = YES;
    }
    if(_category.showFlag == NO)
    {
        _category.hidden = YES;
        _category.showFlag = YES;
    }
    }


}
#pragma mark -sign-
-(NSString*)sign
{
    //这里也需要截取region keyword
//    if([region isEqualToString:@""] == NO)
//    {
//        NSLog(@"小小小小小小小小小小小小小小小小");
//    }
    NSLog(@"------signregion------------%@",region);
    NSString *stringCategory = [@"category"stringByAppendingString:category];
    NSString *stringCity = [@"city"stringByAppendingString:city];
    NSString *stringPage = [@"page"stringByAppendingString:[NSString stringWithFormat:@"%d",page]];
    NSString *stringSort = [@"sort"stringByAppendingString:sort];
   
    NSString *appkey = @"13009273";
        NSString *appsecret = @"c376813f9b3b482cb3c2b51a08d23406";
       //sign生成器
    if([keyword isEqualToString:@""] == YES && [keywordOne isEqualToString:@""] == NO)
    {
        
        keywordOne = [keywordOne substringFromIndex:1];
        keywordOne = [@"keyword"stringByAppendingString:keywordOne];
    }
    

    NSArray *array = [NSArray arrayWithObjects:appkey,stringCategory,stringCity,keyword,keywordOne,stringPage,region,stringSort,appsecret,nil];
    NSMutableArray *mutableArray = [NSMutableArray array];
    NSString *tempkeywordOne = @"";
    for (NSString* stv in array) {
        //取出字符串
        
        if([stv isEqualToString: @""] == YES)
        {
            continue;
        }
        else
        {
            [mutableArray addObject:stv];
        }
    }
    for(int i = 0; i < mutableArray.count;i++)
    {
        NSString *string = [mutableArray objectAtIndex:i];
      tempkeywordOne = [tempkeywordOne stringByAppendingString:string];
        
    }
    NSLog(@"-----------tempkeywordOne------%@",tempkeywordOne);
    //用傻1加密
    NSString *tempCode =  [tempkeywordOne sha1:tempkeywordOne];
    NSString *code = [tempCode uppercaseString];
    NSLog(@"-----------sign------%@",code);
    return [[code retain]autorelease];

}
#pragma mark -网络请求-
//网络请求的方法,通知接收传值的地方，由其他页面传送过来的
-(void)requestGetUrl:(NSNotification*)notifiation
{
  //每次单独请求的都是都是从第一页开始，下拉加载肯定不能走这个方法
    page = 0;
    category = self.selected;
    //城市 分区(子分区) 分类(子分类) sign 关键字(分区的下属区域) page  sort
    NSDictionary *tempDictionary = notifiation.object;
    NSArray *array = [tempDictionary allKeys];
    //取出字典的键
    NSString *key = [array objectAtIndex:0];
   
    //判断分区，子分区，分类 ，子分类，排序方式
    if([key isEqualToString:@"region"] == YES)
    {
        //取出字典的值
        NSString *selectedValue = [tempDictionary objectForKey:key];
        //selectedValue = [selectedValue substringFromIndex:6];
        
        region = selectedValue;
    }
    if([key isEqualToString:@"subRegion"] == YES)
    {
        NSArray *selectedValue = [tempDictionary objectForKey:key];
        
        region = [selectedValue objectAtIndex:0];
        NSLog(@"走了这个理哦哦哦哦哦哦哦哦哦%@",region);
//        region = [region substringFromIndex:6];
        keyword = [selectedValue objectAtIndex:1];
       // keyword = [keyword substringFromIndex:7];
    
    }
    if([key isEqualToString:@"category"] == YES)
    {
        NSString *selectedValue = [tempDictionary objectForKey:key];
        category = selectedValue;
    }
    if([key isEqualToString:@"subCategory"] == YES)
    {
        NSArray *selectedValue = [tempDictionary objectForKey:key];
        category = [selectedValue objectAtIndex:0];
        keywordOne = [selectedValue objectAtIndex:1];
 
        
    }
    if([key isEqualToString:@"sort"] == YES)
    {
        NSString *selectedValue = [tempDictionary objectForKey:key];
        sort = selectedValue;
    }

    
    //获取用户所选择的城市
    NSUserDefaults *selectedCity = [NSUserDefaults standardUserDefaults];
    _selectedCityString = [selectedCity objectForKey:SELECTED_CITY_KEY];
    //获取城市
    city = _selectedCityString;
    NSLog(@"----------region------%@",region);
    NSLog(@"----------keyword------%@",keyword);
    NSLog(@"--------keywordOne--------%@",keywordOne);
    NSLog(@"---------city-------%@",city);
    NSLog(@"-----------category-----%@",category);
  
    [self getNetworkIn];
}

-(void)categoryAction:(id)sender
{
    _category.showFlag = !_category.showFlag;
    if(_category.showFlag == YES)
    {
        _category.hidden = YES;
    }
    else
    {
        _category.hidden = NO;
    }
    
    if(_menu.showFlag == NO)
    {
        _menu.hidden = YES;
        _menu.showFlag = YES;
    }
    if(_sort.showFlag == NO)
    {
        _sort.hidden = YES;
        _sort.showFlag = YES;
    }
    _tableView.tableHeaderView = nil;

}
//实现导航按钮
-(void)cityAction:(id)sender
{
    _menu.showFlag = !_menu.showFlag;
    if(_menu.showFlag == YES)
    {
        _menu.hidden = YES;
    }
    else
    {
        _menu.hidden = NO;
    }
    if(_category.showFlag == NO)
    {
        _category.hidden = YES;
        _category.showFlag = YES;
    }
    if(_sort.showFlag == NO)
    {
        _sort.hidden = YES;
        _sort.showFlag = YES;
    }
    _tableView.tableHeaderView = nil;
}
//排序方式
-(void)sortAction:(id)sender
{
  
    _sort.showFlag = !_sort.showFlag;
    if(_sort.showFlag == YES)
    {
        _sort.hidden = YES;
    }
    else
    {
        _sort.hidden = NO;
    }
    if(_category.showFlag == NO)
    {
        _category.hidden = YES;
        _category.showFlag = YES;
    }
    if(_menu.showFlag == NO)
    {
        _menu.hidden = YES;
        _menu.showFlag = YES;
    }
    _tableView.tableHeaderView = nil;

}
#pragma mark -receive network request data-
-(void)allCitys:(NSDictionary*)dictionary
{
    
    //默认请求下来是20条数据
    NSArray *firstArray = [dictionary objectForKey:@"deals"];
    for(int i = 0;i < firstArray.count;i++)
    {
        NSDictionary *tempDictionary = firstArray[i];
        ShopingModule *module = [[ShopingModule alloc]initWithShopInfos:tempDictionary];
        [self.dataMutableArray addObject:module];
        RELEASE_SAFETY(module);
    }
    
    [_tableView reloadData];
    
}
#pragma mark - tableView dataSource-
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
       return  self.dataMutableArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    //标识符是用来区分重用cell的  还是有几种cell的
    static NSString *identifier = @"CELL";
    MyCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if(cell == nil)
    {
        cell = [[[MyCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier]autorelease];
    }
    ShopingModule *module = [self.dataMutableArray objectAtIndex:indexPath.row];
    cell.titleLabel.text = module.title;
    [cell.headImageView setImageWithURL:[NSURL URLWithString:module.s_image_url]];
    cell.saleLabel.text =[@"¥" stringByAppendingString:[NSString stringWithFormat:@"%@",module.current_price]];
    cell.personLabel.text = [[NSString stringWithFormat:@"%@",module.purchase_count]stringByAppendingString:@"人"];
    NSMutableAttributedString *editString = [[NSMutableAttributedString alloc]initWithString:[@"¥" stringByAppendingString:[NSString stringWithFormat:@"%@",module.list_price]]];
    [editString addAttribute:(NSString *)NSStrikethroughStyleAttributeName
                  value:(id)[NSNumber numberWithInt:NSUnderlineStyleThick]
                  range:NSMakeRange(0,editString.string.length)];
    cell.discountLabel.attributedText = editString;
    RELEASE_SAFETY(editString);
   // cell.addressLabel.text = module.regions;
       return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"已经选择拉已经选择拉已经选择拉已经选择拉已经选择拉");
    ShopingModule *module = [self.dataMutableArray objectAtIndex:indexPath.row];
    GroupdetailViewController *groupDetail = [[GroupdetailViewController alloc]init];
    groupDetail.module = module;
    _result = @"second";
    [self.navigationController pushViewController:groupDetail animated:YES];
    [groupDetail release];
}
#pragma mark -第三方下拉刷新，上提加载-
- (void)addFooter
{
    //__unsafe_unretained GroupListViewController *vc = self;
    __block GroupListViewController *tc = self;
    MJRefreshFooterView *footer = [MJRefreshFooterView footer];
    footer.scrollView = _tableView;
    footer.beginRefreshingBlock = ^(MJRefreshBaseView *refreshView) {
        //增加5条假数据
//                        for (int i = 0; i<5; i++) {
//                            int random = arc4random_uniform(1000000);
//                           [self.dataMutableArray addObject:[NSString stringWithFormat:@"数据---%d", random]];
//                        }
        
      //  [tc getCity:nil getCategory:nil getRegin:nil getSubKeyWord:nil getSort:nil];
        [tc getNetworkIn];
        // 模拟延迟加载数据，因此2秒后才调用）
        // 这里的refreshView其实就是footer
        [tc performSelector:@selector(doneWithView:) withObject:refreshView afterDelay:2.0];
        
        NSLog(@"%@----开始进入刷新状态", refreshView.class);
    };
    _footer = footer;
}
- (void)addHeader
{
    //__unsafe_unretained GroupListViewController *vc = self;
    __block GroupListViewController *vc = self;
    MJRefreshHeaderView *header = [MJRefreshHeaderView header];
    header.scrollView = _tableView;
    header.beginRefreshingBlock = ^(MJRefreshBaseView *refreshView) {
        // 进入刷新状态就会回调这个Block,他会自动判断，当滑动到最下面的时候，会回掉这个block,我们可以在这里再继续网络请求20条以后的数据，后面的数据，通过insertObject添加到数组中
        
        
        // 模拟延迟加载数据，因此2秒后才调用）
        // 这里的refreshView其实就是header
        [vc performSelector:@selector(doneWithView:) withObject:refreshView afterDelay:2.0];
        
        NSLog(@"%@----开始进入刷新状态", refreshView.class);
    };
    header.endStateChangeBlock = ^(MJRefreshBaseView *refreshView) {
        // 刷新完毕就会回调这个Block
        NSLog(@"%@----刷新完毕", refreshView.class);
    };
    header.refreshStateChangeBlock = ^(MJRefreshBaseView *refreshView, MJRefreshState state) {
        // 控件的刷新状态切换了就会调用这个block
        switch (state) {
            case MJRefreshStateNormal:
                NSLog(@"%@----切换到：普通状态", refreshView.class);
                break;
                
            case MJRefreshStatePulling:
                NSLog(@"%@----切换到：松开即可刷新的状态", refreshView.class);
                break;
                
            case MJRefreshStateRefreshing:
                NSLog(@"%@----切换到：正在刷新状态", refreshView.class);
                break;
            default:
                break;
        }
    };
    [header beginRefreshing];
    _header = header;
}
- (void)doneWithView:(MJRefreshBaseView *)refreshView
{
    // 刷新表格
    [_tableView reloadData];
    // (最好在刷新表格后调用)调用endRefreshing可以结束刷新状态
    [refreshView endRefreshing];
}
//网络请求方法,city城市,category分类(电影，酒店),regin城市分区,subKeyWord分类子分类,sort排序方式，第一次进来，还有上提加载用这个。
#pragma mark -网络请求,刚进入的时候-
-(void)getEnter
{
    page++;
    //这个方法只让上提加载的时候执行。
    //像viewwillappear这样的方法，再把这个方法拷贝一分，别让page＋＋，然后选择上面的某一项的时候，让index，设置为0；
    int pageOne = 1;
    //获取用户所选择的城市
    NSUserDefaults *selectedCity = [NSUserDefaults standardUserDefaults];
  _selectedCityString = [selectedCity objectForKey:SELECTED_CITY_KEY];
    city = _selectedCityString;
    //页数
    NSString *paget = [NSString stringWithFormat:@"%d",pageOne];
    //获取sign签名
    NSString *tempSign = [self sign];
    //获取用户选择的是酒店还是电影
    
    
    [requestManager getSelectedCity:_selectedCityString andCategory:self.selected andSign:tempSign andSort:sort andPage:paget];
    
    
}
//释放内存
-(void)dealloc
{
    //移除通知
    [[NSNotificationCenter defaultCenter]removeObserver:self name:IDENTIFIERURL object:nil];
    [_header free];
    [_footer free];
    [requestManager release];
    [_dataMutableArray release];
    [super dealloc];
}
//本类的网络请求
-(void)getNetworkIn
{
    
    page++;
    //page注意，后面那三个都需要判断
   NSString *stringURL =[NSString stringWithFormat:@"http://api.dianping.com/v1/deal/find_deals?city=%@&category=%@&page=%@&sort=%@",city,category,[NSString stringWithFormat:@"%d",page],sort];
    NSLog(@"+++++++++玩笑+++++++%@",region);
    if([region isEqualToString:@""] == NO)
    {
      NSString  *tempregion = [region substringFromIndex:6];
        stringURL = [stringURL stringByAppendingString:[NSString stringWithFormat:@"&region=%@",tempregion]];
    }
    if([keyword isEqualToString:@""] == NO)
    {
       NSString *tempkeyword = [keyword substringFromIndex:7];
        stringURL = [stringURL stringByAppendingString:[NSString stringWithFormat:@"&keyword=%@",tempkeyword]];
    }
    if([keywordOne isEqualToString:@""] == NO && [keyword isEqualToString:@""] == NO)
    {
        stringURL = [stringURL stringByAppendingString:[NSString stringWithFormat:@"%@",keywordOne]];
    }
    if([keywordOne isEqualToString:@""] == NO &&  [keyword isEqualToString:@""] == YES)
    {
       NSString  *tempkeywordOne = [keywordOne substringFromIndex:1];
        stringURL = [stringURL stringByAppendingString:[NSString stringWithFormat:@"&keyword=%@",tempkeywordOne]];
    }
    NSString *signe = [self sign];
    stringURL = [stringURL stringByAppendingString:[NSString stringWithFormat:@"&appkey=13009273&sign=%@",signe]];
    NSLog(@"---------标识-标识标识-标识-----%@",stringURL);
    //拼接完毕
    NSString *encodeingLink = [stringURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    //获取链接请求
    ASIHTTPRequest *requestOne = [[ASIHTTPRequest alloc]initWithURL:[NSURL URLWithString:encodeingLink]] ;
    //设置代理
    [requestOne setDelegate:self];
    //开启异步
    [requestOne startAsynchronous];
   
}
- (void)requestFinished:(ASIHTTPRequest *)request
{
    //这几个页面都是alloc都是不同的对象，不同的对象，有不同的代理。
    NSDictionary *dictionary = [NSDictionary dictionary];
    NSData *responseData = [request responseData];
    dictionary = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableContainers error:nil];
    NSArray *firstArray = [dictionary objectForKey:@"deals"];
    [self.dataMutableArray removeAllObjects];
    for(int i = 0;i < firstArray.count;i++)
    {
        NSDictionary *tempDictionary = firstArray[i];
        ShopingModule *module = [[ShopingModule alloc]initWithShopInfos:tempDictionary];
        
        [self.dataMutableArray addObject:module];
        // NSLog(@"----------%@",module.title);
        RELEASE_SAFETY(module);
    }
    if(self.dataMutableArray.count == 0)
    {
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 320, 30)];
        label.font = [UIFont systemFontOfSize:14];
        label.textColor = [UIColor grayColor];
        label.textAlignment = NSTextAlignmentCenter;
        label.text = @"无搜索记录";
        label.backgroundColor = [UIColor clearColor];
        _tableView.tableHeaderView = label;
        [label release],label = nil;
    }
    else
    {
        _tableView.tableHeaderView = nil;
    }

    [_tableView reloadData];

}
- (void)requestFailed:(ASIHTTPRequest *)request
{
    NSError *error = [request error];
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
