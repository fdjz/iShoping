//
//  fdjzAppDelegate.h
//  IShoping
//
//  Created by SHENFENG125 on 14-4-12.
//  Copyright (c) 2014年 Cuwoyinyue. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Reachability.h"
@interface fdjzAppDelegate : UIResponder <UIApplicationDelegate,UIAlertViewDelegate>
{
    Reachability *_hostReach;
    BOOL flag;
}
@property(nonatomic,retain)UIAlertView *alterView;
@property (retain, nonatomic) UIWindow *window;

@end
