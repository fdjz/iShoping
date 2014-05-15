//
//  MainViewController.m
//  IShoping
//
//  Created by SHENFENG125 on 14-4-12.
//  Copyright (c) 2014年 Cuwoyinyue. All rights reserved.
//

#import "MainViewController.h"
#import "HomeViewController.h"
#import "MineViewController.h"
#import "MoreViewController.h"
#import "AllViewController.h"
#import "BaseViewController.h"
#import "AutoScrollView.h"
@interface MainViewController ()
{
    //定义主页 我的　更多　全城等页面
    HomeViewController *_homeViewController;
    MineViewController *_mineViewController;
    MoreViewController *_moreViewController;
    AllViewController *_allViewController;
    
}
-(void)_initShowViewControllers;
@end

@implementation MainViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        //隐藏tabBar
        //[self.tabBar setHidden:YES];
        //[self.tabBar setBackgroundImage:[UIImage imageNamed:@"tabBar_background.png"]];
        self.delegate = self;
        self.tabBar.tintColor = [UIColor orangeColor];
        self.tabBar.barTintColor = [UIColor whiteColor];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    //调用初始化tabBar
    [self _initShowViewControllers];
}
#pragma mark -初始化tabBar的item
-(void)_initShowViewControllers
{
    //实例化主页、全城、我的、更多等页面
    _homeViewController = [[HomeViewController alloc]init];
    _allViewController = [[AllViewController alloc]init];
    _moreViewController = [[MoreViewController alloc]init];
    _mineViewController = [[MineViewController alloc]init];
    
    //存到数组当中
    NSArray *viewsArray = @[_homeViewController,_allViewController,_mineViewController,_moreViewController];
    
    //释放页面
    RELEASE_SAFETY(_homeViewController);
    RELEASE_SAFETY(_moreViewController);
    RELEASE_SAFETY(_mineViewController);
    RELEASE_SAFETY(_allViewController);
    
    //声明数组
    NSMutableArray *viewControllers = [NSMutableArray arrayWithCapacity:viewsArray.count];
    for (id obj in viewsArray)
    {
        if([obj isKindOfClass:[UIViewController class]])
        {
            BaseViewController *baseViewController = [[BaseViewController alloc]initWithRootViewController:(UIViewController*)obj];
            [viewControllers addObject:baseViewController];
            RELEASE_SAFETY(baseViewController);
        }
    }
    
    //将所有页面控制器添加到tabBar上面
    self.viewControllers = viewControllers;
    
    
}
#pragma mark - scrollView协议方法－
- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
