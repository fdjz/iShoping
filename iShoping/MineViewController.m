//
//  MineViewController.m
//  IShoping
//
//  Created by SHENFENG125 on 14-4-12.
//  Copyright (c) 2014年 Cuwoyinyue. All rights reserved.
//

#import "MineViewController.h"

@interface MineViewController ()

@end

@implementation MineViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
         self.title = @"我的";
        //为tabBar添加图标
        UITabBarItem *moreTabBar = [[UITabBarItem alloc]initWithTitle:@"我的" image:[UIImage imageNamed:@"TabMe.png"] selectedImage:[UIImage imageNamed:@"TabMeSelected.png"]];
        self.tabBarItem = moreTabBar;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [button setTitle:@"清空缓存" forState:UIControlStateNormal];
    [button setBackgroundColor:[UIColor orangeColor]];
    button.frame = CGRectMake(0, 128, 320, 30);
    [self.view addSubview:button];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
