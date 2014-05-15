//
//  AutoScrollView.m
//  iShoping
//
//  Created by SHENFENG125 on 14-4-17.
//  Copyright (c) 2014年 Cuwoyinyue. All rights reserved.
//


#import "AutoScrollView.h"

#define kPageControlHeight 20

@interface UIScrollView (ScrollViewPageNo)

- (NSInteger)pageNo;

@end

@implementation UIScrollView (ScrollViewPageNo)

- (NSInteger)pageNo
{
    int pageNo = self.contentOffset.x / self.frame.size.width + 0.5;
    return pageNo;
}

@end

@interface AutoScrollView ()
{
    UIScrollView *_scrollView;
    UIPageControl *_pageControl;
    NSTimer *_timer;
    int _currentPage;
    BOOL _autoScrollFlag;
}

@end

@implementation AutoScrollView

- (void)dealloc
{
    [_scrollView release];
    [_pageControl release];
    [_timer invalidate];
    
    [super dealloc];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [self initWithFrame:frame imageNames:nil];
    return self;
}

//  designate initializer
- (instancetype)initWithFrame:(CGRect)frame imageNames:(NSArray *)imageNames
{
    self = [super initWithFrame:frame];
    if (self) {
        _autoScrollFlag = YES;
        self.imageNames = imageNames;
        [self addSubControl];
        _timer = [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(timeUp:) userInfo:nil repeats:YES];
    }
    return self;
}

- (void)addSubControl
{
    _scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
    [self addSubview:_scrollView];
    CGSize contentSize = _scrollView.bounds.size;
    contentSize.width *= [_imageNames count] + 2;
    //  设置可滚动区域
    [_scrollView setContentSize:contentSize];
    //  设置是否分页显示
    [_scrollView setPagingEnabled:YES];
    
    CGRect rect = _scrollView.bounds;
    
    //  在最前面添加最后一页
    UIImageView *aView = [[[UIImageView alloc] initWithFrame:rect] autorelease];
    aView.contentMode = UIViewContentModeScaleAspectFill;
    NSArray *nameArray = [[_imageNames lastObject] componentsSeparatedByString:@"."];
    NSString *imagePath = [[NSBundle mainBundle] pathForResource:[nameArray firstObject] ofType:[nameArray lastObject]];
    UIImage *image = [UIImage imageWithContentsOfFile:imagePath];
    [aView setImage:image];
    aView.frame = rect;
    [_scrollView addSubview:aView];
    
    for (int i = 0; i < _imageNames.count; i++) {
        rect.origin.x += rect.size.width;
  
        UIImageView *aView = [[[UIImageView alloc] initWithFrame:rect] autorelease];
        aView.contentMode = UIViewContentModeScaleAspectFill;
        //        UIImage *image = [UIImage imageNamed:[_imageNames objectAtIndex:i]];  //  初始化成功后会被系统缓存 不能释放
        NSArray *nameArray = [[_imageNames objectAtIndex:i] componentsSeparatedByString:@"."];
        NSString *imagePath = [[NSBundle mainBundle] pathForResource:[nameArray firstObject] ofType:[nameArray lastObject]];
        UIImage *image = [UIImage imageWithContentsOfFile:imagePath];
        [aView setImage:image];
        aView.frame = rect;
        [_scrollView addSubview:aView];
    }
    
    //  在最前面添加最后一页
    rect.origin.x += rect.size.width;
    UIImageView *bView = [[[UIImageView alloc] initWithFrame:rect] autorelease];
    bView.contentMode = UIViewContentModeScaleAspectFill;
    nameArray = [[_imageNames firstObject] componentsSeparatedByString:@"."];
    imagePath = [[NSBundle mainBundle] pathForResource:[nameArray firstObject] ofType:[nameArray lastObject]];
    image = [UIImage imageWithContentsOfFile:imagePath];
    [bView setImage:image];
    bView.frame = rect;
    [_scrollView addSubview:bView];
    
    
    //  代理指针不能用retain只能用assign的原因是防止父对象做子对象代理的时候产生循环引用
    _scrollView.delegate = self;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    [_scrollView release];
    
    [_scrollView setContentOffset:CGPointMake(_scrollView.bounds.size.width, 0)];
    
    _pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, self.frame.size.height - kPageControlHeight, self.frame.size.width, kPageControlHeight)];
    [self addSubview:_pageControl];
    [_pageControl setNumberOfPages:_imageNames.count];
    [_pageControl setPageIndicatorTintColor:[UIColor grayColor]];
    [_pageControl setCurrentPageIndicatorTintColor:[UIColor redColor]];
    
}

+ (instancetype)autoScrollViewWithFrame:(CGRect)frame imageNames:(NSArray *)imageNames
{
    AutoScrollView *autoScorllView = [[AutoScrollView alloc] initWithFrame:frame imageNames:imageNames];
    return [autoScorllView autorelease];
}


- (void)timeUp:(id)sender
{
    if (_autoScrollFlag) {
        CGPoint contentOffset = CGPointMake((_scrollView.pageNo + 1) * _scrollView.bounds.size.width, 0);
        [_scrollView setContentOffset:contentOffset animated:YES];
    }
}

NSString *stringFromCGPoint(CGPoint point)
{
    NSString *string = [NSString stringWithFormat:@"{%f, %f}", point.x, point.y];
    return [[string retain] autorelease];
}

#pragma mark -
#pragma mark scrollView delegate method

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    _autoScrollFlag = NO;
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset
{
    _autoScrollFlag = YES;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    //    NSLog(@"%@", NSStringFromCGPoint(scrollView.contentOffset));
    int pageNo = scrollView.pageNo;
    if (pageNo == _currentPage) {
        return;
    }
    _currentPage = pageNo;
    pageNo--;
    CGPoint contentOffset = scrollView.contentOffset;
//    if (-1 == pageNo) {
//        contentOffset.x += scrollView.frame.size.width * _imageNames.count;
//        [scrollView setContentOffset:contentOffset];
//        pageNo = _imageNames.count - 1;
//    }
    if (_imageNames.count == pageNo){
        contentOffset.x -= scrollView.frame.size.width * _imageNames.count;
        [scrollView setContentOffset:contentOffset];
        pageNo = 0;
    }
    
    [_pageControl setCurrentPage:pageNo];
}


@end



