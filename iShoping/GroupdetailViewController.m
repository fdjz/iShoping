//
//  GroupdetailViewController.m
//  iShoping
//
//  Created by SHENFENG125 on 14-4-17.
//  Copyright (c) 2014年 Cuwoyinyue. All rights reserved.
//

#import "GroupdetailViewController.h"
#import "UIImageView+WebCache.h"
#import "NSString+ShaOnePass.h"
#import "ASIHTTPRequest.h"
@interface GroupdetailViewController ()
{
    //显示图片
    UIImageView *_imageView;
    //视图,添加立即支付button，和显示价格label。
    UIView *_view;
    //团购详情
    UITextView *_detailTextView;
    //特别提醒，购买须知
    UITextView *_remindTextView;
    //关于影城简介
    UITextView *_aboutTextView;
    //价格label
    UILabel *_label;
    //立即抢购
    UIButton *_shopButton;
    //scrollview滚动
    UIScrollView *userGuideScrollView;
    //获取团购所在地址
    UILabel *addressLabel;
    
}
@end

@implementation GroupdetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"团购详情";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.198
    //网络请求.576
    [self network];
    userGuideScrollView = [[UIScrollView alloc]initWithFrame:self.view.bounds];
    self.edgesForExtendedLayout = UIRectEdgeNone;
       //如下是对scrollView的属性设置的部分
    //1//  contentsize是内容的宽和高，contentsize.width是内容的宽度，contentsize.heght是高度，contentsize是UIScrollView的一个属性，它是一个CGSize，是由核心图形所定义的架构
    userGuideScrollView.contentSize = CGSizeMake(userGuideScrollView.bounds.size.width, userGuideScrollView.bounds.size.height*1.2);
    userGuideScrollView.bounces =YES;
    //隐藏边上指示条
    userGuideScrollView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:userGuideScrollView];
    RELEASE_SAFETY(userGuideScrollView);
    //初始化_imageView
    _imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320, 198)];
    //设置图片
    [_imageView setImageWithURL:[NSURL URLWithString:_module.image_url]];
     //添加到view上显示
    [userGuideScrollView addSubview:_imageView];
    RELEASE_SAFETY(_imageView);
    
    //初始化view,24
    _view = [[UIView alloc]initWithFrame:CGRectMake(0,198 , 320, self.view.bounds.size.height/10)];
    _view.backgroundColor = [UIColor clearColor];
    [userGuideScrollView addSubview:_view];
    RELEASE_SAFETY(_view);
    
    //初始化价格
    _label = [[UILabel alloc]initWithFrame:CGRectMake(20, 10, 80, self.view.bounds.size.height/10)];
    _label.text = [@"¥" stringByAppendingString:[NSString stringWithFormat:@"%@",_module.current_price]];
    _label.textColor = [UIColor orangeColor];
    _label.font = [UIFont systemFontOfSize:32];
    [_view addSubview:_label];
    RELEASE_SAFETY(_label);
    
    //初始化原价
    NSMutableAttributedString *editWrite = [[NSMutableAttributedString alloc]initWithString:[@"¥" stringByAppendingString:[NSString stringWithFormat:@"%@",_module.list_price]]];
    [editWrite addAttribute:(NSString *)NSStrikethroughStyleAttributeName
                       value:(id)[NSNumber numberWithInt:NSUnderlineStyleThick]
                       range:NSMakeRange(0,editWrite.string.length)];
    UILabel *discountLabel = [[UILabel alloc]initWithFrame:CGRectMake(98, 14, 100, self.view.bounds.size.height/10)];
    discountLabel.attributedText = editWrite;
    discountLabel.textColor = [UIColor grayColor];
    discountLabel.font = [UIFont systemFontOfSize:14];
    [_view addSubview:discountLabel];
    RELEASE_SAFETY(editWrite);
    RELEASE_SAFETY(discountLabel);
    
    //初始化提交按钮
    _shopButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [_shopButton setTitle:@"立即抢购" forState:UIControlStateNormal];
    [_shopButton setFrame:CGRectMake(200, 5, 110, self.view.bounds.size.height/10)];
    [_shopButton setBackgroundColor:[UIColor orangeColor]];
    [_shopButton setTitleColor:[UIColor blueColor] forState:UIControlStateHighlighted];
    [_shopButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_view addSubview:_shopButton];
    //1.45
   //分割线
    UIView *separatorView = [[UIView alloc]initWithFrame:CGRectMake(0, 256, 320, 1)];
    if(self.view.bounds.size.height == 568)
    {
        separatorView.frame = CGRectMake(0, 266, 320, 1);
    }
    separatorView.backgroundColor = [UIColor orangeColor];
    [userGuideScrollView addSubview:separatorView];
    RELEASE_SAFETY(separatorView);
    //具体店名
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(10, 286, 320, 20)];
    if(self.view.bounds.size.height == 480)
    {
        label.frame = CGRectMake(10, 274, 320, 20);
    }
    NSArray *dictionary = _module.businesses;
    if(dictionary.count != 0)
    {
    NSDictionary *dict = [dictionary objectAtIndex:0];
   NSString *string = [dict objectForKey:@"name"];
        label.font = [UIFont boldSystemFontOfSize:18];
        label.textColor = [UIColor brownColor];
    label.text = string;
    }
    label.backgroundColor = [UIColor clearColor];
    [userGuideScrollView addSubview:label];
    RELEASE_SAFETY(label);
    //初始化影城简介
    _aboutTextView = [[UITextView alloc]initWithFrame:CGRectMake(6,308, 320-12,self.view.bounds.size.height/6)];
    if(self.view.bounds.size.height == 480)
    {
        _aboutTextView.frame = CGRectMake(6, 298, 320-12, self.view.bounds.size.height/6);
    }
    _aboutTextView.text = [@"简介: " stringByAppendingString: _module.description ];
    _aboutTextView.font = [UIFont systemFontOfSize:15];
    _aboutTextView.textColor = [UIColor grayColor];
    [userGuideScrollView addSubview:_aboutTextView];
    RELEASE_SAFETY(_aboutTextView);
    
    //分割线
    UIView *separatorViewr = [[UIView alloc]initWithFrame:CGRectMake(0, 388, 320, 1)];
    if(self.view.bounds.size.height == 568)
    {
        separatorViewr.frame = CGRectMake(0, 398, 320, 1);
    }
    separatorViewr.backgroundColor = [UIColor orangeColor];
    [userGuideScrollView addSubview:separatorViewr];
    RELEASE_SAFETY(separatorViewr);

    //获取团购所在地址
    addressLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 396, 314, self.view.bounds.size.height/24)];
    addressLabel.numberOfLines = 0;
    
    
 
    //给this加上下划线，value可以在指定的枚举中选择
    addressLabel.font = [UIFont systemFontOfSize:15];
    addressLabel.text = [@"地址:        " stringByAppendingString:@"正在获取中..."];
    addressLabel.textColor = [UIColor blackColor];
    [userGuideScrollView addSubview:addressLabel];
    RELEASE_SAFETY(addressLabel);
    
    //添加地图定位
    UILabel *locationLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 396+self.view.bounds.size.height/20, 40, self.view.bounds.size.height/24)];
    locationLabel.font = [UIFont systemFontOfSize:15];
    locationLabel.text = @"定位:";
    [userGuideScrollView addSubview:locationLabel];
    
    RELEASE_SAFETY(locationLabel);
    //添加定位图片
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
   
    [button setFrame:CGRectMake(48, 396+self.view.bounds.size.height/20, 30, self.view.bounds.size.height/24)];
    [button setBackgroundImage:[UIImage imageNamed:@"location.png"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(handleAction:) forControlEvents:UIControlEventTouchUpInside];
    [userGuideScrollView addSubview:button];

    
    //添加我的定位
    UILabel *melocationLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 396+self.view.bounds.size.height/20+self.view.bounds.size.height/20, 80, self.view.bounds.size.height/24)];
    melocationLabel.font = [UIFont systemFontOfSize:15];
    melocationLabel.text = @"我的位置:";
    [userGuideScrollView addSubview:melocationLabel];
    RELEASE_SAFETY(melocationLabel);
    
    //添加定位图片
    UIButton *mebutton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [mebutton setBackgroundImage:[UIImage imageNamed:@"location.png"] forState:UIControlStateNormal];
    [mebutton setFrame:CGRectMake(80, 396+self.view.bounds.size.height/20+self.view.bounds.size.height/20, 30, self.view.bounds.size.height/24)];
    [userGuideScrollView addSubview:mebutton];

    
    //开始导航
    UILabel *maplocationLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 396+self.view.bounds.size.height/20+self.view.bounds.size.height/20+self.view.bounds.size.height/20, 100, self.view.bounds.size.height/24)];
    maplocationLabel.font = [UIFont systemFontOfSize:15];
    maplocationLabel.text = @"地图路线查看:";
    [userGuideScrollView addSubview:maplocationLabel];
    RELEASE_SAFETY(maplocationLabel);
    
    
    UIButton *mapbutton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [mapbutton setBackgroundImage:[UIImage imageNamed:@"navigation.png"] forState:UIControlStateNormal];
    [mapbutton setFrame:CGRectMake(112, 396+self.view.bounds.size.height/20+self.view.bounds.size.height/20+self.view.bounds.size.height/20, 30, self.view.bounds.size.height/24)];
    [userGuideScrollView addSubview:mapbutton];

}
//sign生成器
-(NSString*)sign:(NSString*)deal
{
    NSString *appkey = @"13009273";
    NSString *appsecret = @"c376813f9b3b482cb3c2b51a08d23406";
    NSString *tempDealId = [@"deal_id" stringByAppendingString:deal];
    NSString *readSign = [[appkey stringByAppendingString:tempDealId]stringByAppendingString:appsecret];
    NSString *vs =  [readSign sha1:readSign];
    NSString *sign = [vs uppercaseString];
    return sign;
    
}
-(void)network
{
    //详细地址
    NSString *deal_id = _module.deal_id;
    //获取sign
    NSString *sign = [self sign:deal_id];
    //url
    NSString *url =[NSString stringWithFormat:@"http://api.dianping.com/v1/deal/get_single_deal?deal_id=%@&appkey=13009273&sign=%@",deal_id,sign] ;
    //对于链接进行编码
    NSString *encodeingLink = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    //进行网络请求
    ASIHTTPRequest *requestOne = [[ASIHTTPRequest alloc]initWithURL:[NSURL URLWithString:encodeingLink]] ;
    //设置代理
    [requestOne setDelegate:self];
    //开启异步
    [requestOne startAsynchronous];

}
//网络请求的方法

- (void)requestFinished:(ASIHTTPRequest *)request
{
    self.dictionary = [NSDictionary dictionary];
    NSData *responseData = [request responseData];
    self.dictionary = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableContainers error:nil];
  
    //在这里可以获取团购详情，如下代码
    /*status":"OK","count":1,"deals":[{"deal_id":"14-5259645","title":"金逸影城","description":"仅售35元,价值110元2D/3D电影票1张!大片连连,精彩纷呈!现代化星级影城,高端观影设备,感受震撼视觉享受!","city":"福州","list_price":110.0,"current_price":35.0,"regions":["宝龙万象"],"categories":["电影"],"purchase_count":6430,"purchase_deadline":"2014-04-30","publish_date":"2014-03-01","details":"团购详情\n 凭大众点评网团购券可享受以下内容：\n\n-福州宝龙店2D/3D电影票（1张，价值110元）\n\n注\n• 不限时段\n• 观看4K影片需补差5元/张，两张团购券可升级为IMAX电影票1张\n• 法定节假日到店另付10元/张\n\n\n \n","image_url":"http://t1.s1.dpfile.com/pc/mc/f6103d2cfa05aa69adb38e0b39fdfcee(450x280)/thumb.jpg","s_image_url":"http://t1.s2.dpfile.com/pc/mc/f6103d2cfa05aa69adb38e0b39fdfcee(160x100)/thumb.jpg","more_image_urls":["http://t2.s1.dpfile.com/pc/mc/f6103d2cfa05aa69adb38e0b39fdfcee(450x1024)/thumb.jpg"],"more_s_image_urls":["http://t2.s1.dpfile.com/pc/mc/f6103d2cfa05aa69adb38e0b39fdfcee(450x1024)/thumb_1.jpg"],"is_popular":1,"restrictions":{"is_reservation_required":0,"is_refundable":1,"special_tips":"购买须知\n \n有效期 \n2014-03-01 至 2014-04-30\n \n预约 \n无需预约\n \n使用须知 \n如遇限价影片需另补差价，具体详情见影院通告\n \n温馨提示 \n不可与其他优惠同享\n每张团购券仅限兑换观影当日或次日电影票；\n现场选座，首映式/情侣座/VIP厅观影/见面会不可用；\n免费提供3D眼镜，无需押金；4.1.3M（不含）以下儿童在成人陪同下可免费观看电影（含3D），且每位家长限带1名免票儿童，无座位，观看儿童片、特殊影厅（如3D影片、VIP厅等）需使用美团券或购票； \n特殊影片/限价影片需补差价，具体规则以影城公告为准；\n \n \n"},"notice":"","deal_url":"http://dpurl.cn/p/kllmXA60tH","deal_h5_url":"http://dpurl.cn/p/9aLBHosrs4","commission_ratio":0.03,"businesses":[{"name":"金逸影城(宝龙店)","id":2085679,"city":"福州","address":"工业路193号宝龙城市广场5楼","latitude":26.061958,"longitude":119.29112,"url":"http://dpurl.cn/p/9ujfy0bEHz","h5_url":"http://dpurl.cn/p/nzvmheHEp0"}]}]}*/
    NSLog(@"+++++++++++++%@",self.dictionary);
    //取出address地址
    NSArray *arry = [self.dictionary objectForKey:@"deals"];
    NSDictionary *dictionary  = [arry objectAtIndex:0];
    NSArray *array = [dictionary objectForKey:@"businesses"];
    NSDictionary *dic = [array objectAtIndex:0];
    NSString *string = [dic objectForKey:@"address"];
    addressLabel.text = [@"地址:"stringByAppendingString:string];
    
}
- (void)requestFailed:(ASIHTTPRequest *)request
{
    NSError *error = [request error];
    
}
-(void)handleAction:(id)sender
{
    NSLog(@"神神神神神神神神神神神神神神神神神神");
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)dealloc
{
    [_module release];
    [super dealloc];
}
@end
