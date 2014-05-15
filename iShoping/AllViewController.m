//
//  AllViewController.m
//  IShoping
//
//  Created by SHENFENG125 on 14-4-12.
//  Copyright (c) 2014年 Cuwoyinyue. All rights reserved.
//

#import "AllViewController.h"

@interface AllViewController ()

@end

@implementation AllViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"全城";
        //为tabBar添加图标
        UITabBarItem *moreTabBar = [[UITabBarItem alloc]initWithTitle:@"全城" image:[UIImage imageNamed:@"TabAll.png"] selectedImage:[UIImage imageNamed:@"TabAll.png"]];
        self.tabBarItem = moreTabBar;

    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
