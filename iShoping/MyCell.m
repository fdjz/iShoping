//
//  MyCell.m
//  iShoping
//
//  Created by SHENFENG125 on 14-4-17.
//  Copyright (c) 2014年 Cuwoyinyue. All rights reserved.
//

#import "MyCell.h"
@interface MyCell()

@end
@implementation MyCell
-(void)dealloc
{
    [self.discountLabel release];
    [self.addressLabel release];
    [self.personLabel release];
    [self.saleLabel release];
    [self.titleLabel release];
    [self.headImageView release];
    [super dealloc];
}
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        //初始化imageView
        self.headImageView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 80, 50)];
        [self.contentView addSubview:self.headImageView];
        //初始化标题label
        self.titleLabel = [[[UILabel alloc]initWithFrame:CGRectMake(100, 10, 210, 20)]autorelease];
        self.titleLabel.font = [UIFont systemFontOfSize:14];
        self.titleLabel.textColor = [UIColor blackColor];
        [self.contentView addSubview:self.titleLabel];
        //初始化价格label
        self.saleLabel = [[[UILabel alloc]initWithFrame:CGRectMake(100, 30, 60, 15)]autorelease];
        self.saleLabel.textColor = [UIColor orangeColor];
        self.saleLabel.font = [UIFont systemFontOfSize:15];
        [self.contentView addSubview:self.saleLabel];
        //初始化评论人数label
        self.personLabel = [[[UILabel alloc]initWithFrame:CGRectMake(100, 45, 120, 15)]autorelease];
        self.personLabel.textColor = [UIColor grayColor];
        self.personLabel.font = [UIFont systemFontOfSize:12];
        [self.contentView addSubview:self.personLabel];
        //初始化原价label
        self.discountLabel = [[[UILabel alloc]initWithFrame:CGRectMake(140, 30, 60, 15)]autorelease];
        self.discountLabel.textColor = [UIColor grayColor];
        self.discountLabel.font = [UIFont systemFontOfSize:10];
        [self.contentView addSubview:self.discountLabel];
        //初始化分区label
        self.addressLabel = [[[UILabel alloc]initWithFrame:CGRectMake(245, 45, 75, 15)]autorelease];
        self.addressLabel.textColor = [UIColor grayColor];
        [self.contentView addSubview:self.addressLabel];
        
        
        
        
        
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
