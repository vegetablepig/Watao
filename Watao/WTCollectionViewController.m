//
//  WTCollectionViewController.c
//  Watao
//
//  Created by fc on 14-8-21.
//  Copyright (c) 2014年 连 承亮. All rights reserved.
//

#import "WTCollectionViewController.h"
#import "WTTexutureManager.h"
#import "WTAppDelegate.h"

@implementation WTCollectionViewController

@synthesize button;

/*- (IBAction)saved1:(id)sender {
    _pottery = [[WTPottery alloc] WTPotteryIH:WT_INIT_HEIGHT IR:WT_INIT_RADIUS MINH:WT_MIN_HEIGHT MINR:WT_MIN_RADIUS MAXH:WT_MAX_HEIGHT MAXR:WT_MAX_RADIUS TH:WT_THICKNESS];
    //read config from file
    //[self readConfig:@"config.plist"];
    //NSLog(@"%@",config);
    //NSString *str = [config objectForKey:@"isPotterySaved"];
    //if ([str isEqualToString:@"true"]){
        [_pottery loadFromFile:@"temp.wt"];
    //}
}*/

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *imgPath = [documentsDirectory stringByAppendingPathComponent:@"collect1.png"];
    UIImage* tmp = [UIImage imageWithContentsOfFile:imgPath];
    [button setBackgroundImage: tmp forState:UIControlStateNormal];
}




- (IBAction)collection1:(id)sender {
    WTAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    
    appDelegate.pottery = [[WTPottery alloc] WTPotteryIH:WT_INIT_HEIGHT IR:WT_INIT_RADIUS MINH:WT_MIN_HEIGHT MINR:WT_MIN_RADIUS MAXH:WT_MAX_HEIGHT MAXR:WT_MAX_RADIUS TH:WT_THICKNESS];
    [appDelegate.pottery loadFromFile:@"savedWt1.wt"];
    appDelegate.textureManager = [[WTTexutureManager alloc] initFromFile:@"savedTexture1.png"];
    [appDelegate.textureManager loadtexture];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *imgPath = [documentsDirectory stringByAppendingPathComponent:@"collect1.png"];
    UIImage* tmp = [UIImage imageWithContentsOfFile:imgPath];
    appDelegate.finishimage = tmp;
    //read config from file
    //[self readConfig:@"config.plist"];
    //NSLog(@"%@",config);=
    //NSString *str = [config objectForKey:@"isPotterySaved"];
    //if ([str isEqualToString:@"true"]){
    
    //NSLog(@"path: %@",imgPath);
    
}

/*
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
    if (([self.view window] == nil)) {
        //transform the model world according to gravity
    }
    // Dispose of any resources that can be recreated.
}*/

@end