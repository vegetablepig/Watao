//
//  ViewController.h
//  animation
//
//  Created by fc on 14-5-12.
//  Copyright (c) 2014年 fc. All rights reserved.
//

#import "WTPotteryViewController.h"
#import "AVFoundation/AVFoundation.h"

@interface WTFlashViewController : WTPotteryViewController
{
    NSMutableArray * dataSet;
    NSMutableArray * ImgSet;
    NSArray *arr;
    AVAudioPlayer *myBackMusic;
    BOOL animating;
    int flag;
    
}
@property (weak, nonatomic) IBOutlet UIProgressView *progress1;
@property (weak, nonatomic) IBOutlet UILabel *label;
@property (nonatomic) NSDate* mydate;

@end
