//
//  WTTutorViewController.c
//  Watao
//
//  Created by fc on 14-8-21.
//  Copyright (c) 2014年 连 承亮. All rights reserved.
//

#import "WTTutorViewController.h"
#import "WTTexutureManager.h"
#import "WTAppDelegate.h"

@implementation WTTutorViewController

@synthesize back;

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self addScrollView];
    [self.view bringSubviewToFront:back];
    //[self addPageControl];
    
}

-(void)addScrollView {
    WTAppDelegate *delegate = [[UIApplication sharedApplication] delegate];
    imageScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, delegate.width, delegate.height)];
    imageScrollView.backgroundColor = [UIColor clearColor];
    imageScrollView.contentSize = CGSizeMake(delegate.width*7, delegate.height);    // 设置内容大小
    imageScrollView.delegate = self;
    imageScrollView.pagingEnabled = YES;
    imageScrollView.showsHorizontalScrollIndicator = NO;//滚动的时候是否有水平的滚动条，默认是有的
    int a = 0;
    for (int i = 0; i < 7; i++) {
        
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0+a, 0, delegate.width, delegate.height)];
        imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"jc%d.jpg",i+1]];
        imageView.tag = 110 + i;
        imageView.userInteractionEnabled=YES;//与用户交互
        [imageScrollView addSubview:imageView];
        
        //为UIImageView添加点击手势
        UITapGestureRecognizer *tap;
        tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
        tap.numberOfTapsRequired = 1;//tap次数
        tap.numberOfTouchesRequired = 1;//手指数
        //[imageView addGestureRecognizer:tap];
        
        a += delegate.width;
    }
    
    [self.view addSubview:imageScrollView];
}

//添加PageControl
/*-(void) addPageControl {
    
    pageControl = [[UIPageControl alloc]initWithFrame:CGRectMake(768/2-150, 440, 320, 40)];
    pageControl.numberOfPages = 11;//页数（几个圆圈）
    pageControl.tag = 101;
    pageControl.currentPage = 0;
    
    [self.view addSubview:pageControl];
    
}


-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
    int current = scrollView.contentOffset.x/400;
    NSLog(@"current:%d",current);
    pageControl.currentPage = current;
}*/

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
    if (([self.view window] == nil)) {
        _pottery = nil;
        imageScrollView = nil;
        pageControl = nil;
        //transform the model world according to gravity
    }
    // Dispose of any resources that can be recreated.
}


@end