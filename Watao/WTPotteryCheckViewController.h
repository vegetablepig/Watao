//
//  WTPotteryCheckViewController.h
//  Watao
//
//  Created by 连 承亮 on 14-5-6.
//  Copyright (c) 2014年 连 承亮. All rights reserved.
//

#import "WTPotteryViewController.h"

@interface WTPotteryCheckViewController : WTPotteryViewController <CheckPotteryDelegate>{
    bool _changeFlag;
    WTPottery* nPottery;
    float *ra;
    bool _colFlag;
    float vv;
    
}
@property (weak, nonatomic) IBOutlet UIButton *bSave;
@property (weak, nonatomic) IBOutlet UIImageView *vSnapshot;
@property (weak, nonatomic) IBOutlet UISlider *slider;
@property (nonatomic) GLuint frameBuffer;
@property (nonatomic) GLuint renderBuffer;
@property (nonatomic) GLuint depthBuffer;
@property (weak, nonatomic) IBOutlet UIImageView *u1;
@property (weak, nonatomic) IBOutlet UIImageView *u11;
@property (weak, nonatomic) IBOutlet UIImageView *u2;
@property (weak, nonatomic) IBOutlet UIImageView *u21;

- (IBAction)sliderchanged:(id)sender;
-(IBAction)changeViewPoint:(UIPanGestureRecognizer*)paramSender;

-(IBAction)saveIt:(id)sender;
- (IBAction)share:(id)sender;

@end
