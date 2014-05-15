//
//  MainViewController.h
//  IShoping
//
//  Created by SHENFENG125 on 14-4-12.
//  Copyright (c) 2014年 Cuwoyinyue. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AutoScrollView.h"
@interface MainViewController : UITabBarController<UITabBarControllerDelegate>
@property(nonatomic,retain)AutoScrollView *autoscrollView;
@end
