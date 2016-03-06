//
//  WTPotteryChooseViewController.m
//  Watao
//
//  Created by fc on 14-7-25.
//  Copyright (c) 2014年 连 承亮. All rights reserved.
//

#import "WTPotteryChooseViewController.h"
#import "WTTexutureManager.h"
//#import "UMSocial.h"
#import "WTAppDelegate.h"


@implementation WTPotteryChooseViewController

@synthesize qinghua;
@synthesize youshang;


- (void)viewDidLoad
{
    [super viewDidLoad];
    [youshang setAdjustsImageWhenHighlighted:NO];
    [qinghua setAdjustsImageWhenHighlighted:NO];
    //WTAppDelegate *delegate = [[UIApplication sharedApplication] delegate];
    //WTTexutureManager *manager = delegate.textureManager;
}
- (IBAction)rightDown:(id)sender {
    [youshang setImage:[UIImage imageNamed:@"right_down.png"] forState:UIControlStateNormal];
}

- (IBAction)leftDown:(id)sender {
    [qinghua setImage:[UIImage imageNamed:@"left_down.png"] forState:UIControlStateNormal];
}

- (IBAction)chooseqing:(id)sender {
    [qinghua setImage:[UIImage imageNamed:@"left_up.png"] forState:UIControlStateNormal];
    WTAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    appDelegate.attatchTexMode = WT_MODE_QINHUA;
    appDelegate.backTexName = @"clay.png";
    [appDelegate.textureManager clearTexture:appDelegate.backTexName];
}
- (IBAction)chooseyou:(id)sender {
    [youshang setImage:[UIImage imageNamed:@"right_up.png"] forState:UIControlStateNormal];
    WTAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    appDelegate.attatchTexMode = WT_MODE_YANSE;
    appDelegate.backTexName = @"whiteBackTexture.jpg";
    [appDelegate.textureManager clearTexture:appDelegate.backTexName];
}

@end