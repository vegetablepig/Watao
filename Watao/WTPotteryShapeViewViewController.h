//
//  WTPotteryShapeViewViewController.h
//  Watao
//
//  Created by 连 承亮 on 14-3-23.
//  Copyright (c) 2014年 连 承亮. All rights reserved.
//

#import "WTPotteryViewController.h"
#import "AVFoundation/AVFoundation.h"

#define upload_image @"http://watao-test.jian-yin.com/index.php/webservices/mage_upload"


@interface WTPotteryShapeViewViewController : WTPotteryViewController{// <ShapePotteryDelegate>{
    bool _isShapeStarted;
    bool _isButtonPressed;
    AVAudioPlayer *myBackMusic;
    NSTimer *_timer;
}

@property (weak, nonatomic) IBOutlet UIButton *start;
@property (weak, nonatomic) IBOutlet UIButton *fare;
@property (weak, nonatomic) IBOutlet UIButton *account;
@property (weak, nonatomic) IBOutlet UIButton *info;
@property (weak, nonatomic) IBOutlet UIImageView *line;
@property (weak, nonatomic) IBOutlet UIImageView *imgLogo;
//@property (weak, nonatomic) IBOutlet UIImageView *gridBackground;
//home button
@property (weak, nonatomic) IBOutlet UIImageView *operatingBar;
@property (weak, nonatomic) IBOutlet UIButton *attachTex;
@property (weak, nonatomic) IBOutlet UIButton *home;
@property (weak, nonatomic) IBOutlet UIButton *clear;
@property (weak, nonatomic) IBOutlet UIButton *classicShape;
//operating bar icons
- (IBAction)savePotteryShape:(id)sender;
- (IBAction)loadPotteryShape:(id)sender;


@property (nonatomic) int classicalPotteryChoosen;
@property (nonatomic) BOOL isChoosingClassical;

-(IBAction)shape:(UIPanGestureRecognizer *)paramSender;
-(IBAction)startShape:(id)sender;
-(IBAction)resetShape:(id)sender;
-(IBAction)backHome:(id)sender;
- (IBAction)keep:(id)sender;
- (IBAction)info:(id)sender;
- (IBAction)next:(id)sender;


//
- (IBAction)choosePottery1:(id)sender;
- (IBAction)choosePottery2:(id)sender;
- (IBAction)choosePottery3:(id)sender;
- (IBAction)choosePottery4:(id)sender;
- (IBAction)choosePottery5:(id)sender;
- (IBAction)choosePottery6:(id)sender;
- (IBAction)choosePottery7:(id)sender;
- (IBAction)choosePottery8:(id)sender;
- (IBAction)choosePottery9:(id)sender;
//
@property (weak, nonatomic) IBOutlet UIImageView *test;

@property (weak, nonatomic) IBOutlet UIButton *bCP1;
@property (weak, nonatomic) IBOutlet UIButton *bCP2;
@property (weak, nonatomic) IBOutlet UIButton *bCP3;
@property (weak, nonatomic) IBOutlet UIButton *bCP4;
@property (weak, nonatomic) IBOutlet UIButton *bCP5;
@property (weak, nonatomic) IBOutlet UIButton *bCP6;
@property (weak, nonatomic) IBOutlet UIButton *bCP8;
@property (weak, nonatomic) IBOutlet UIButton *bCP7;
@property (weak, nonatomic) IBOutlet UIButton *bCP9;
@property (weak, nonatomic) IBOutlet UIImageView *shelf;
//
@property (weak, nonatomic) IBOutlet UIButton *bYes;
@property (weak, nonatomic) IBOutlet UIButton *bNo;
- (IBAction)pressYes:(id)sender;
- (IBAction)pressCancel:(id)sender;
//
@property (weak, nonatomic) IBOutlet UIImageView *chooseFrame1;
@property (weak, nonatomic) IBOutlet UIImageView *chooseFrame2;
@property (weak, nonatomic) IBOutlet UIImageView *chooseFrame3;
@property (weak, nonatomic) IBOutlet UIImageView *chooseFrame4;
@property (weak, nonatomic) IBOutlet UIImageView *chooseFrame5;
@property (weak, nonatomic) IBOutlet UIImageView *chooseFrame6;
@property (weak, nonatomic) IBOutlet UIImageView *chooseFrame7;
@property (weak, nonatomic) IBOutlet UIImageView *chooseFrame8;
//choose
- (IBAction)chooseClassical:(id)sender;

@end
