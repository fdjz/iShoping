//
//  fdjzAppDelegate.m
//  IShoping
//
//  Created by SHENFENG125 on 14-4-12.
//  Copyright (c) 2014年 Cuwoyinyue. All rights reserved.
//

#import "fdjzAppDelegate.h"
#import "MainViewController.h"
@implementation fdjzAppDelegate
//问题：tabBar2x图片具体怎么加上去？？？？？？？？
//spotlight  setting   app  portrait  landscape他们分别是什么意思？
//utils这个文件夹里面都放什么？
//那个图标ios 5、6 或者ios 7图标 是不是你用ios5系统他就显示ios5图标？
//当我鼠标点击的时候，让timer先停止滚动？？？
//点击的时候最好让timer那个方法什么代码也不执行，设置一个bool值判断，但是imageview不象button，没有按下和弹起的事件。怎么版？？？？
//NSString *string  ＝ @“wo ai wo jia”；   @“wo ai wo jia”这个值是不是保存栈中....

//#define GROUP_SALES_SEARCH_URL(__kCity__,__kPosition_加下划线只是一种习惯而已，参数加，具体替换的时候也要加，关键替换的时候加下滑线不就是替换成下滑线拉嘛，为什么加不加下划线它替换出来的东西都是一样的
//为什么参数字符串前面加@  @"http://api.dianping.
//在GroupListViewController的dealloc中，释放free就奔溃
//[self.mutableArray insertObjects:array atIndexes:0];atIndexes是索引集合 ，怎么用？？
//在同一页面，建立三个textView，然后用gcd建立一个队列oper..然后在这队列开辟三个线程，同时进行网络请求,问网络请求那样些是否合理
//layoutSubviews是不是重写layoutSubviews，然后导航条下面的添加的东西就有0变成64了？？？？
//城市页面城市出来从左向右滑
//找gcd单例
//列表页面给tableview添加单击手势不相应didselectedrowatindexpath方法。


//bug列表
//1.当点击分类的时候，如果先选择的有子分类，然后再选择没有子分类的，例如电影，旅游，就会蹦
//2.当选择了子分区 然后再去选择子分类就会蹦。
//3.释放free那块
// UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(10, 286, 320, 20)];
//if(self.view.bounds.size.height == 480)
//{
//    label.frame = CGRectMake(10, 274, 320, 20);
//}这种方式屏幕适配合理吗
//怎么往服务器里写数据？？？？这个必须弄好
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]]autorelease];
    //初始化MainViewController
    MainViewController *mainVC = [[MainViewController alloc]init];
    //指定window的根视图控制器
    _window.rootViewController = mainVC;
    //释放内存
    RELEASE_SAFETY(mainVC);
    
    flag = YES;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reachabilityChanged:) name:kReachabilityChangedNotification object:nil];
    _hostReach = [[Reachability reachabilityWithHostName:@"www.apple.com"] retain];
    [_hostReach startNotifier];
    
    
    
    
    
    
   
// Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    return YES;
}
//对于网络进行实时监听
- (void)reachabilityChanged:(NSNotification *)note{
    Reachability *curReach = [note object];
    NSParameterAssert([curReach isKindOfClass:[Reachability class]]);
    NetworkStatus status = [curReach currentReachabilityStatus];
    if (status == 0)
    {
        if(flag == YES)
        {
        [self showAlert:@"网络不给力"];
        flag = NO;
        }
    }
    else
    {
        [self showAlert:@"网络已恢复"];
        flag = YES;
    }
 
}

- (void)timerFireMethod:(NSTimer*)theTimer
{
    UIAlertView *promptAlert = (UIAlertView*)[theTimer userInfo];
    [promptAlert dismissWithClickedButtonIndex:0 animated:YES];
    [promptAlert release];
}

- (void)showAlert:(NSString *)message
{
    UIAlertView *promptAlert = [[UIAlertView alloc] initWithTitle:@"提示:" message:message delegate:nil cancelButtonTitle:nil otherButtonTitles:nil];

    [NSTimer scheduledTimerWithTimeInterval:1.0f
                                     target:self
                                   selector:@selector(timerFireMethod:)
                                   userInfo:promptAlert
                                    repeats:NO];
    
    [promptAlert show];
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
