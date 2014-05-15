//
//  AutoScrollView.h
//  iShoping
//
//  Created by SHENFENG125 on 14-4-17.
//  Copyright (c) 2014年 Cuwoyinyue. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AutoScrollView : UIView<UIScrollViewDelegate>

@property (nonatomic, retain) NSArray *imageNames;
- (instancetype)initWithFrame:(CGRect)frame imageNames:(NSArray *)imageNames;
+ (instancetype)autoScrollViewWithFrame:(CGRect)frame imageNames:(NSArray *)imageNames;

@end
