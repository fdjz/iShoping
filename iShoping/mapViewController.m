//
//  mapViewController.m
//  iShoping
//
//  Created by SHENFENG125 on 14-4-29.
//  Copyright (c) 2014年 Cuwoyinyue. All rights reserved.
//

#import "mapViewController.h"

@interface mapViewController ()

@end

@implementation mapViewController

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
    MKMapView *map = [[MKMapView alloc]initWithFrame:CGRectMake(0, 50, 320, 430)];
    map.mapType = MKMapTypeStandard;
    map.delegate = self;
    
   
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
