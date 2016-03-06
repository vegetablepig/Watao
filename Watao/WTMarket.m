//
//  WTMarket.m
//  Watao
//
//  Created by vegetablepig on 15-3-25.
//  Copyright (c) 2015年 连 承亮. All rights reserved.
//


#import "WTMarket.h"

@implementation WTMarket

@synthesize WebView;
@synthesize back;

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSURLRequest *request =[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://weidian.com/s/259682588"]];
    [self.view addSubview: WebView];
    [WebView loadRequest:request];
    [WebView setUserInteractionEnabled:YES];
    //[self buttonPress:nil];
    // Do any additional setup after loading the view from its nib.
}
/*

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
    if (([self.view window] == nil)) {
        activityIndicatorView = nil;
        //transform the model world according to gravity
    }
    // Dispose of any resources that can be recreated.
}*/


- (void)viewWillDisappear:(BOOL)animated
{
    [WebView removeFromSuperview];
    WebView = nil;
    
}


@end